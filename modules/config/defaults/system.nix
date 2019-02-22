{ config, lib, ... }:

with lib;

let

  cfg = config.quixops.defaults.system;
  enabled = cfg.enable;

in
{
  options.quixops.defaults.system = {
    enable = mkEnableOption "Enable the Quixops system configuration defaults.";
  };

  config = mkIf enabled {

    i18n.defaultLocale = "en_US.UTF-8";
    services.logrotate.enable = true;
    sound.enable = false;
    time.timeZone = "Etc/UTC";

  };
}
