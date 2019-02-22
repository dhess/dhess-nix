# Special configuration for BeagleBone {Black,Green} boards.

{ config, lib, pkgs, ... }:

with lib;

let

  localLib = import ../../../lib.nix;
  cfg = config.quixops.hardware.beaglebone;
  enabled = cfg.enable;

in
{
  options.quixops.hardware.beaglebone = {
    enable = mkEnableOption "Enable BeagleBone-specific hardware configuration.";
  };

  config = mkIf enabled {
    nixpkgs.localSystem.system = "armv7l-linux";

    boot.loader.grub.enable = false;
    boot.loader.generic-extlinux-compatible.enable = true;

    nixpkgs.config.platform = (import "${localLib.fetchNixPkgs}" { config = {} ; }).platforms.beaglebone;
    boot.kernelPackages = pkgs.linuxPackages_beagleboard;
    hardware.firmware = [ pkgs.bb-org-overlays];

    # Manual doesn't currently evaluate on ARM
    services.nixosManual.enable = false;
  };
}
