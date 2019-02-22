# Configuration common to MBR/GRUB systems.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.dhess-nix.hardware.mbr;
  uefi_enabled = config.dhess-nix.hardware.uefi.enable;
  enabled = cfg.enable;

in
{
  options.dhess-nix.hardware.mbr = {
    enable = mkEnableOption "Enable GRUB for MBR-based boot.";
  };

  config = mkIf enabled {
    assertions = [
      { assertion = ! uefi_enabled;
        message = "Both 'dhess-nix.hardware.mbr' and 'dhess-nix.hardware.uefi' cannot be enabled";
      }
    ];

    boot.loader.grub.enable = true;
    boot.loader.grub.version = 2;
  };
}
