# Configuration common to Intel Coffee Lake physical hardware systems.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.dhess-nix.hardware.intel.coffee-lake;
  enabled = cfg.enable;

in
{
  options.dhess-nix.hardware.intel.coffee-lake = {
    enable = mkEnableOption "Enable Intel Coffee Lake hardware configuration.";
  };

  config = mkIf enabled {
    dhess-nix.hardware.intel.common.enable = true;
    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" ];
  };
}
