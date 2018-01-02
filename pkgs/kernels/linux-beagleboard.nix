{ stdenv, hostPlatform, fetchFromGitHub, perl, buildLinux, ... } @ args:

let
  localLib = import ../../lib.nix;
  modDirVersion = "4.9.69";
  tag = "r85";
in
import "${localLib.fetchNixPkgs}/pkgs/os-specific/linux/kernel/generic.nix" (args // rec {
  version = "${modDirVersion}-ti-${tag}";
  inherit modDirVersion;

  src = fetchFromGitHub {
    owner = "beagleboard";
    repo = "linux";
    rev = "${version}";
    sha256 = "1bv2fmj4ldrj8njg167xgwr0swf80hn8h87p2drkrdb7d6c1qvyf";
  };

  kernelPatches = args.kernelPatches;

  features = {
    efiBootStub = false;
  } // (args.features or {});

  extraMeta.hydraPlatforms = [ "armv7l-linux" ];
} // (args.argsOverride or {}))
