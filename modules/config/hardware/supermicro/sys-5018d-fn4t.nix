# SuperMicro 5018D-FN4T system.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.dhess-nix.hardware.supermicro.sys-5018d-fn4t;
  enabled = cfg.enable;

in
{
  options.dhess-nix.hardware.supermicro.sys-5018d-fn4t = {
    enable = mkEnableOption "Enable Supermicro 5018D-FN4T hardware configuration.";
  };

  config = mkIf enabled {
    dhess-nix.hardware.intel.broadwell-de.enable = true;
    boot.kernelModules = [ "coretemp" "jc42" "nct6775" ];
  };
}
