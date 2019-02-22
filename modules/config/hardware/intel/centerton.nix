# Configuration common to Intel Centerton (Atom Processor S Series)
# hardware systems.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.quixops.hardware.intel.centerton;
  enabled = cfg.enable;

in
{
  options.quixops.hardware.intel.centerton = {
    enable = mkEnableOption "Enable Intel Centerton hardware configuration.";
  };

  config = mkIf enabled {
    quixops.hardware.intel.common.enable = true;
    boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
  };
}
