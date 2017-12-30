self: super:

let

  inherit (super) callPackage linuxPackagesFor kernelPatches;

in rec
{

  linux_beagleboard = callPackage ../pkgs/kernels/linux-beagleboard.nix {
    kernelPatches =
      [ kernelPatches.bridge_stp_helper
        kernelPatches.cpu-cgroup-v2."4.9"
        kernelPatches.modinst_arg_list_too_long
      ];
  };

  linuxPackages_beagleboard = linuxPackagesFor linux_beagleboard;

}
