# Configuration common to Intel Haswell systems.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.quixops.hardware.intel.haswell;
  enabled = cfg.enable;

in
{
  options.quixops.hardware.intel.haswell = {
    enable = mkEnableOption "Enable Intel Haswell hardware configuration.";
  };

  config = mkIf enabled {
    quixops.hardware.intel.common.enable = true;
    boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  };
}
