# Configuration common to Intel Haswell systems.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.dhess-nix.hardware.intel.haswell;
  enabled = cfg.enable;

in
{
  options.dhess-nix.hardware.intel.haswell = {
    enable = mkEnableOption "Enable Intel Haswell hardware configuration.";
  };

  config = mkIf enabled {
    dhess-nix.hardware.intel.common.enable = true;
    boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  };
}
