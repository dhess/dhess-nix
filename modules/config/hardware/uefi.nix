# Configuration common to UEFI systems.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.dhess-nix.hardware.uefi;
  mbr_enabled = config.dhess-nix.hardware.mbr.enable;
  enabled = cfg.enable;

in
{
  options.dhess-nix.hardware.uefi = {
    enable = mkEnableOption "Enable the systemd-boot EFI boot loader.";
  };

  config = mkIf enabled {
    assertions = [
      { assertion = ! mbr_enabled;
        message = "Both 'dhess-nix.hardware.mbr' and 'dhess-nix.hardware.uefi' cannot be enabled";
      }
    ];

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
