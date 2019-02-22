{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.quixops.defaults.tmux;
  enabled = cfg.enable;

in
{
  options.quixops.defaults.tmux = {
    enable = mkEnableOption "Enable the Quixops tmux configuration defaults.";
  };

  config = mkIf enabled {
    programs.tmux = {
      enable = true;
      shortcut = "z";
      terminal = "screen-256color";
    };
  };
}
