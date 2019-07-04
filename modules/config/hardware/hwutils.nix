# Things that should generally be installed on physical hardware
# systems.

{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.dhess-nix.hardware.hwutils;
  enabled = cfg.enable;

in
{
  options.dhess-nix.hardware.hwutils = {
    enable = mkEnableOption ''
      packages that are useful for managing physical hardware.
    '';
  };

  config = mkIf enabled {
    environment.systemPackages = with pkgs; [
      flashrom
      lm_sensors
      pciutils
      usbutils
    ];
  };
}
