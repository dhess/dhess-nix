{ config, lib, pkgs, ... }:

with lib;

let

  globalCfg = config.services.mellon-auto-unlock;

  unlockScript = cfg:
  ''
    LOCKDATE=$(${pkgs.coreutils}/bin/date --iso-8601=seconds --date='TZ="${cfg.lockTimeTZ}" ${cfg.lockTime}')
    ${pkgs.curl}/bin/curl --fail -X PUT --header 'Content-Type: application/json' --header 'Accept: application/json' -d "{ \"until\": \"$LOCKDATE\", \"state\": \"Unlocked\" }" '${cfg.mellonUrl}/state'
  '';

in {

  options.services.mellon-auto-unlock = {

    locks = mkOption {
      type = types.attrsOf (types.submodule (
        { config, options, name, ... }:
        {
          options = {

            description = mkOption {
              type = types.str;
              example = "Front door daily auto-unlock";
              description = ''
                A short description of the service.
              '';
            };

            mellonUrl = mkOption {
              type = pkgs.lib.types.nonEmptyStr;
              example = "http://mellon.example.com";
              description = ''
                The URL of the mellon service controlling the lock.
              '';
            };

            unlockTime = mkOption {
              type = pkgs.lib.types.nonEmptyStr;
              example = "07:00";
              description = ''
                A <literal>systemd</literal> calendar expression
                indicating when to unlock the lock. See
                <citerefentry><refentrytitle>systemd.time</refentrytitle>
                <manvolnum>7</manvolnum></citerefentry>.

                (Note that, due to limitations in
                <literal>systemd</literal>, unlock times can only be
                given in the system's local time or UTC.)
                ''; };

            lockTimeTZ = mkOption {
              type = pkgs.lib.types.nonEmptyStr;
              default = "America/Los_Angeles";
              example = "Etc/UTC";
              description = ''
                A Unix timezone-style time zone which specifies in
                which timezone the lock time is to be interpreted.
              '';
            };

            lockTime = mkOption {
              type = pkgs.lib.types.nonEmptyStr;
              example = "10:00pm today";
              description = ''
                A <citerefentry><refentrytitle>date</refentrytitle>
                <manvolnum>1</manvolnum></citerefentry>-style date
                string which specifies at which time the lock will be
                locked. Note that if the lock time is earlier than the
                unlock time, <literal>mellon</literal> will ignore the
                request.
              '';
            };
          };
        }
      ));

      default = {};
      description = ''
        Declarative lock configurations. Each lock appears as a
        service named
        <literal>mellon-auto-unlock@<replaceable>name</replaceable></literal>
        on the host system and is triggered by a
        <citerefentry><refentrytitle>systemd.timer</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry>. The timer is
        persistent, so that if a timer is missed while the host is off
        or sleeping, it will fire again when the host resumes
        operation.
      '';
    };
  };

  config = mkIf (globalCfg.locks != {}) {

    systemd.services = listToAttrs (filter (x: x.value != null) (
      (mapAttrsToList
         (lockName: lockCfg: nameValuePair "mellon-auto-unlock@${lockName}" ({
            description = lockCfg.description;
            after = [ "multi-user.target" ];
            script = unlockScript lockCfg;
            serviceConfig = {
              User = "nobody";
              Group = "nogroup";
              Type = "oneshot";
            };
          }
      )) globalCfg.locks)
    ));

    systemd.timers = listToAttrs (filter (x: x.value != null)
      (mapAttrsToList
        (lockName: lockCfg: nameValuePair "mellon-auto-unlock@${lockName}" ({
           wantedBy = [ "timers.target" ];
           timerConfig = {
             OnCalendar = lockCfg.unlockTime;
             Persistent = "yes";
           };
          })
        ) globalCfg.locks));

  };

  meta.maintainers = lib.maintainers.dhess-pers;

}
