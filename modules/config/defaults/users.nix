{ config, lib, ... }:

with lib;

let

  cfg = config.quixops.defaults.users;
  enabled = cfg.enable;

in
{
  options.quixops.defaults.users = {
    enable = mkEnableOption "Enable the Quixops user configuration defaults.";
  };

  config = mkIf enabled {

    users.mutableUsers = false;

  };
}
