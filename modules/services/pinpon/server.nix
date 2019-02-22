# A PinPon server, i.e., the bit that relays notifications to an
# Internet service from a PinPon client.

{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.pinpon;
  enabled = cfg.enable;
  stateDir = "/var/lib/pinpon";

  key = config.quixops.keychain.keys.aws-pinpon;

  pinponScript = cfg:
  ''
    ${pkgs.pinpon}/bin/pinpon \
      --region ${cfg.awsRegion} \
      --credentials-file ${key.path} \
      --profile ${cfg.awsProfile} \
      --port ${toString cfg.port} \
      --platform ${cfg.snsPlatform} \
      ${cfg.snsTopicName}
  '';
  
in {
  options.services.pinpon = {

    enable = mkEnableOption "A PinPon server.";

    port = mkOption {
      type = pkgs.lib.types.port;
      example = 8917;
      default = 8000;
      description = ''
        The port on which the PinPon server listens.
      '';
    };

    snsTopicName = mkOption {
      type = pkgs.lib.types.nonEmptyStr;
      example = "doorbell";
      description = ''
        The AWS SNS topic to which the PinPon server will subscribe.
      '';
    };

    snsPlatform = mkOption {
      type = types.enum [ "APNS" "APNSSandbox" ];
      default = "APNS";
      example = "APNSSandbox";
      description = ''
        The AWS SNS platform to which PinPon server notifications will
        be sent.
      '';
    };

    awsRegion = mkOption {
      type = pkgs.lib.types.nonEmptyStr;
      example = "us-west-2";
      default = "us-east-1";
      description = ''
        The AWS region in which the PinPon topic was created.
      '';
    };

    awsCredentialsLiteral = mkOption {
      type = pkgs.lib.types.nonEmptyStr;
      description = ''
        The AWS credentials, as a literal stirng.

        Note that this secret will not be copied to the Nix store.
        However, upon start-up, the service will copy a file
        containing the key to the service's state directory.
      '';
    };

    awsProfile = mkOption {
      type = pkgs.lib.types.nonEmptyStr;
      example = "pinpon";
      description = ''
        The name of the AWS profile to use in the credentials literal.
      '';
    };

    description = mkOption {
      type = pkgs.lib.types.nonEmptyStr;
      example = "PinPon server for front door";
      default = "PinPon server";
      description = ''
        A short, one-line description of this PinPon server.
      '';
    };

  };

  config = mkIf enabled {

    quixops.keychain.keys.aws-pinpon = {
      user = "pinpon";
      group = "pinpon";
      destDir = stateDir;
      text = cfg.awsCredentialsLiteral;
    };

    systemd.services.pinpon = {
      description = cfg.description;
      after = [ "multi-user.target" "keys.target" ];
      wants = [ "keys.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.pinpon ];
      script = pinponScript cfg;
      restartIfChanged = true;
      restartTriggers = [ pkgs.pinpon ];

      serviceConfig = {
        PermissionsStartOnly = "true";
        User = "pinpon";
        Group = "pinpon";
        Type = "simple";
        Restart = "always";
        RestartSec = 10;
      };

    };

    users.users.pinpon = {
      description = "pinpon user";
      name = "pinpon";
      group = "pinpon";
      isSystemUser = true;          
    };
    users.extraGroups.pinpon.name = "pinpon";

  };

  meta.maintainers = lib.maintainers.dhess-pers;
}
