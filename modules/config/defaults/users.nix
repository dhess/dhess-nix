{ config, lib, ... }:

with lib;

let

  cfg = config.dhess-nix.defaults.users;
  enabled = cfg.enable;

in
{
  options.dhess-nix.defaults.users = {
    enable = mkEnableOption "the dhess-nix user configuration defaults.";
  };

  config = mkIf enabled {

    users.mutableUsers = false;

  };
}
