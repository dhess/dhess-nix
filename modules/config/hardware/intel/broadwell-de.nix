# Configuration common to Intel Broadwell-DE (Xeon D) physical
# hardware systems.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.dhess-nix.hardware.intel.broadwell-de;
  enabled = cfg.enable;

in
{
  options.dhess-nix.hardware.intel.broadwell-de = {
    enable = mkEnableOption "Enable Intel Broadwell DE hardware configuration.";
  };

  config = mkIf enabled {
    dhess-nix.hardware.intel.common.enable = true;
    boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  };
}
