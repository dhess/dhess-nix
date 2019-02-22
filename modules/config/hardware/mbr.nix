# Configuration common to MBR/GRUB systems.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.quixops.hardware.mbr;
  uefi_enabled = config.quixops.hardware.uefi.enable;
  enabled = cfg.enable;

in
{
  options.quixops.hardware.mbr = {
    enable = mkEnableOption "Enable GRUB for MBR-based boot.";
  };

  config = mkIf enabled {
    assertions = [
      { assertion = ! uefi_enabled;
        message = "Both 'quixops.hardware.mbr' and 'quixops.hardware.uefi' cannot be enabled";
      }
    ];

    boot.loader.grub.enable = true;
    boot.loader.grub.version = 2;
  };
}
