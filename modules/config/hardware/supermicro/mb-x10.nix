# SuperMicro X10 motherboard config.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.quixops.hardware.supermicro.mb-x10;
  enabled = cfg.enable;

in
{
  options.quixops.hardware.supermicro.mb-x10 = {
    enable = mkEnableOption ''
      Enable Supermicro X10 motherboard configuration.

      Note that this motherboard family supports multiple processor
      microarchitectures, so you must separately enable the processor
      platform that corresponds to your hardware.
    '';
  };

  config = mkIf enabled {
    boot.kernelModules = [ "coretemp" "jc42" "nct6775" ];
  };
}
