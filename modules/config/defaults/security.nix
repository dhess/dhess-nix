{ config, lib, ... }:

with lib;

let

  cfg = config.quixops.defaults.security;
  enabled = cfg.enable;

in
{
  options.quixops.defaults.security = {
    enable = mkEnableOption "Enable the Quixops security configuration defaults.";
  };

  config = mkIf enabled {

    boot.cleanTmpDir = true;
    boot.kernel.sysctl = {
      "kernel.unprivileged_bpf_disabled" = 1;
    };

  };
}
