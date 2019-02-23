{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.dhess-nix.defaults.tmux;
  enabled = cfg.enable;

in
{
  options.dhess-nix.defaults.tmux = {
    enable = mkEnableOption "the dhess-nix tmux configuration defaults.";
  };

  config = mkIf enabled {
    programs.tmux = {
      enable = true;
      shortcut = "z";
      terminal = "screen-256color";
    };
  };
}
