self: super:

let

  inherit (super) callPackage linuxPackagesFor kernelPatches;

in rec
{

  linux_beagleboard = callPackage ../pkgs/kernels/linux-beagleboard.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        # See pkgs/os-specific/linux/kernel/cpu-cgroup-v2-patches/README.md
        # when adding a new linux version
        kernelPatches.cpu-cgroup-v2."4.11"
        kernelPatches.modinst_arg_list_too_long
      ];
  };

  linuxPackages_beagleboard = linuxPackagesFor linux_beagleboard;

}
