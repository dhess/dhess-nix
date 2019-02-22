# Configuration common to Intel Coffee Lake physical hardware systems.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.quixops.hardware.intel.coffee-lake;
  enabled = cfg.enable;

in
{
  options.quixops.hardware.intel.coffee-lake = {
    enable = mkEnableOption "Enable Intel Coffee Lake hardware configuration.";
  };

  config = mkIf enabled {
    quixops.hardware.intel.common.enable = true;
    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" ];
  };
}
