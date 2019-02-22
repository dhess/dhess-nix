# Configuration common to UEFI systems.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.quixops.hardware.uefi;
  mbr_enabled = config.quixops.hardware.mbr.enable;
  enabled = cfg.enable;

in
{
  options.quixops.hardware.uefi = {
    enable = mkEnableOption "Enable the systemd-boot EFI boot loader.";
  };

  config = mkIf enabled {
    assertions = [
      { assertion = ! mbr_enabled;
        message = "Both 'quixops.hardware.mbr' and 'quixops.hardware.uefi' cannot be enabled";
      }
    ];

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
