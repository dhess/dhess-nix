{ config, lib, ... }:

with lib;

let

  cfg = config.dhess-nix.defaults.system;
  enabled = cfg.enable;

in
{
  options.dhess-nix.defaults.system = {
    enable = mkEnableOption "the dhess-nix system configuration defaults.";
  };

  config = mkIf enabled {

    i18n.defaultLocale = "en_US.UTF-8";
    services.logrotate.enable = true;
    sound.enable = false;
    time.timeZone = "Etc/UTC";

  };
}
