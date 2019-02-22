# Configuration common to modern AMD physical hardware systems.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.dhess-nix.hardware.amd.common;
  enabled = cfg.enable;
  intelEnabled = config.dhess-nix.hardware.intel.common.enable;

in
{
  options.dhess-nix.hardware.amd.common = {
    enable = mkEnableOption "Enable AMD hardware configuration common to modern AMD platforms.";
  };

  config = mkIf enabled {
    assertions = [
      { assertion = ! intelEnabled;
        message = "Both `dhess-nix.hardware.amd.common` and `dhess-nix.hardware.intel.common` cannot be enabled";
      }
    ];

    nixpkgs.localSystem.system = "x86_64-linux";

    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    hardware.cpu.amd.updateMicrocode = true;

    powerManagement.cpuFreqGovernor = "powersave";

    # irqbalance is still recommended for general-purpose computing.
    # Enable it by default.
    # ref: https://serverfault.com/questions/513807/is-there-still-a-use-for-irqbalance-on-modern-hardware
    services.irqbalance.enable = true;

    hardware.enableAllFirmware = true;
  };
}
