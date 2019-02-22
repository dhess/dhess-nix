# Configuration common to Intel Kaby Lake physical hardware systems.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.quixops.hardware.intel.kaby-lake;
  enabled = cfg.enable;

in
{
  options.quixops.hardware.intel.kaby-lake = {
    enable = mkEnableOption "Enable Intel Kaby Lake hardware configuration.";
  };

  config = mkIf enabled {
    quixops.hardware.intel.common.enable = true;
    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  };
}
