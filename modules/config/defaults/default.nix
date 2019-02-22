{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.dhess-nix.defaults;
  enabled = cfg.enable;

in
{

  options.dhess-nix.defaults = {
    enable = mkEnableOption
    ''
      Enable all of the dhess-nix configuration defaults.

      These defaults will configure a NixOS server according to the
      good security practice. Note that some of the defaults may not
      be appropriate for an interactive desktop system.
    '';
  };

  config = mkIf enabled {

    dhess-nix.defaults = {

      environment.enable = true;
      networking.enable = true;
      nginx.enable = true;
      nix.enable = true;
      security.enable = true;
      ssh.enable = true;
      sudo.enable = true;
      system.enable = true;
      tmux.enable = true;
      users.enable = true;

    };

  };

}
