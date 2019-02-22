{ config, lib, ... }:

with lib;

let

  cfg = config.dhess-nix.defaults.security;
  enabled = cfg.enable;

in
{
  options.dhess-nix.defaults.security = {
    enable = mkEnableOption "Enable the dhess-nix security configuration defaults.";
  };

  config = mkIf enabled {

    boot.cleanTmpDir = true;
    boot.kernel.sysctl = {
      "kernel.unprivileged_bpf_disabled" = 1;
    };

  };
}
