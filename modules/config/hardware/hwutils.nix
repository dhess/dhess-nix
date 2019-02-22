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
      If enabled, install on the host some packages that are useful
      for managing physical hardware.
    '';
  };

  config = mkIf enabled {
    environment.systemPackages = with pkgs; [
      lm_sensors
      pciutils
      usbutils
    ];
  };
}
