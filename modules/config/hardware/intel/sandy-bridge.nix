# Configuration common to Intel Sandy Bridge physical hardware systems.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.dhess-nix.hardware.intel.sandy-bridge;
  enabled = cfg.enable;

in
{
  options.dhess-nix.hardware.intel.sandy-bridge = {
    enable = mkEnableOption "Enable Intel Sandy Bridge hardware configuration.";
  };

  config = mkIf enabled {
    dhess-nix.hardware.intel.common.enable = true;
    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  };
}
