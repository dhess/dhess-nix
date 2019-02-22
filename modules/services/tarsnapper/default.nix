{ config, lib, pkgs, ... }:

with lib;

let
  gcfg = config.services.tarsnapper;
  keychain = config.quixops.keychain.keys;

  key = config.quixops.keychain.keys.tarsnap-key;

  cacheDir = "/var/cache/tarsnap/tarsnapper";

  tarsnapConfigFile = ''
    keyfile ${key.path}
    cachedir ${cacheDir}
    nodump
    print-stats
    checkpoint-bytes 1G
    exclude */tmp/*
    exclude *.core
  '';

  emailScript = pkgs.writeScript "tarsnapper-mail" ''
    #!${pkgs.stdenv.shell}

    ${gcfg.email.sendmailPath} -t <<MAILEND
    To: $1
    From: tarsnapper <${gcfg.email.from}>
    Subject: $2
    Content--Transfer-Encoding: 8bit
    Content-Type: text/plain; charset=UTF-8

    $(systemctl status --full tarsnapper.service)

    MAILEND
  '';

in
{
  options = {
    services.tarsnapper = {
      enable = mkEnableOption "Enable periodic tarsnapper backups.";

      keyLiteral = mkOption {
        type = pkgs.lib.types.nonEmptyStr;
        example = "<key>";
        description = ''
          The tarsnap key which associates this machine with your
          tarsnap account, as a string literal. Create the key with
          <command>tarsnap-keygen</command>.

          Note that this secret will not be copied to the Nix store.
          However, upon start-up, the service will copy a file
          containing the key to the <literal>tarsnapper</literal>
          cache directory.
        '';
      };

      period = mkOption {
        type = pkgs.lib.types.nonEmptyStr;
        example = "hourly";
        description = ''
          Create backups at this interval.

          The period format is described in
          <citerefentry><refentrytitle>systemd.time</refentrytitle>
          <manvolnum>7</manvolnum></citerefentry>.
        '';
      };

      email = {

        sendmailPath = mkOption {
          type = types.path;
          default = "/run/wrappers/bin/sendmail";
          description = ''
            The path to the <literal>sendmail</literal> executable you
            want to use. The default value is the NixOS default
            <literal>sendmail</literal>.
          '';
        };

        from = mkOption {
          type = pkgs.lib.types.nonEmptyStr;
          example = "root@example.com";
          description = ''
            The email address from which backup notifications are
            sent, in the form <literal>username@domain</literal>.
          '';
        };

        toSuccess = mkOption {
          type = pkgs.lib.types.nonEmptyStr;
          example = "root@example.com";
          description = ''
            The email address to which successful backup notifications are sent.
          '';
        };

        toFailure = mkOption {
          type = pkgs.lib.types.nonEmptyStr;
          example = "root@example.com";
          description = ''
            The email address to which failed backup notifications are sent.
          '';
        };
      };

      config = mkOption {
        type = types.str;
        description = ''
          The tarsnapper config.
        '';
      };

    };
  };

  config = mkIf gcfg.enable {

    quixops.keychain.keys.tarsnap-key = {
      destDir = cacheDir;
      text = gcfg.keyLiteral;
    };

    systemd.services.tarsnapper = {
      description = "Tarsnapper backup";
      requires    = [ "network-online.target" ];
      wants       = [ "keys.target" ];
      after       = [ "network-online.target" "keys.target" ];
      onFailure   = [ "tarsnapper-failed.service" ];

      path = with pkgs; [ coreutils iputils nettools tarsnap tarsnapper utillinux ];

      # In order for the persistent tarsnap timer to work reliably, we have to
      # make sure that the tarsnap server is reachable after systemd starts up
      # the service - therefore we sleep in a loop until we can ping the
      # endpoint.
      preStart = ''
        while ! ping -q -c 1 v1-0-0-server.tarsnap.com &> /dev/null; do sleep 3; done
      '';

      script = ''
        set -e

        install -m 0700 -o root -g root -d ${cacheDir} > /dev/null 2>&1 || true

        TIMESTAMP=`date +\%Y\%m\%d-\%H\%M\%S`
        HOSTNAME=`hostname -f`
        tarsnapper -o configfile /etc/tarsnap/tarsnapper-tarsnap.conf --config /etc/tarsnap/tarsnapper.conf make
        ${emailScript} "${gcfg.email.toSuccess}" "$HOSTNAME backup successful ($TIMESTAMP)"
      '';

      serviceConfig = {
        Type = "oneshot";
        IOSchedulingClass = "idle";
        # Unfortunately, this does not work with sendmails that setuid (e.g., Postfix). See
        # https://github.com/NixOS/nixpkgs/issues/26611
        #NoNewPrivileges = "true";
        CapabilityBoundingSet = [ "CAP_DAC_READ_SEARCH" ];
        PermissionsStartOnly = "true";
      };
    };

    systemd.services.tarsnapper-failed = {
      description = "Runs when a tarsnapper backup fails";

      path = [ pkgs.nettools ];

      script = ''
        HOSTNAME=`hostname -f`
        ${emailScript} "${gcfg.email.toFailure}" "$HOSTNAME backup FAILED"
      '';

      serviceConfig = {
        Type = "oneshot";
        User = "nobody";
        Group = "systemd-journal";
      };
    };

    # Note: the timer must be Persistent=true, so that systemd will start it even
    # if e.g. your laptop was asleep while the latest interval occurred.
    systemd.timers.tarsnapper = {
      timerConfig.OnCalendar = gcfg.period;
      timerConfig.Persistent = "true";
      wantedBy = [ "timers.target" ];
    };

    # Put tarsnap, tarsnapper, and their config files in the system environment so that
    # an administrator can easily use them to check the status of backups, restore, etc.

    environment.etc = {
      "tarsnap/tarsnapper-tarsnap.conf" = {
        text = tarsnapConfigFile;
      };

      "tarsnap/tarsnapper.conf" = {
        text = gcfg.config;
      };
    };

    environment.systemPackages = [ pkgs.tarsnap pkgs.tarsnapper ];

  };
}
