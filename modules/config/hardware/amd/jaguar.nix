# Configuration common to AMD Jaguar (G-series) physical hardware systems.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.quixops.hardware.amd.jaguar;
  enabled = cfg.enable;

in
{
  options.quixops.hardware.amd.jaguar = {
    enable = mkEnableOption "Enable AMD Jaguar (G-series) hardware configuration.";
  };

  config = mkIf enabled {
    quixops.hardware.amd.common.enable = true;
    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "ehci_pci" "usb_storage" "sd_mod" "sdhci_pci" ];
  };
}
