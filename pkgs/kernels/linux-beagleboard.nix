{ stdenv, hostPlatform, fetchFromGitHub, perl, buildLinux, ... } @ args:

let
  localLib = import ../../lib.nix;
  modDirVersion = "4.9.68";
  tag = "r83";
in
import "${localLib.fetchNixPkgs}/pkgs/os-specific/linux/kernel/generic.nix" (args // rec {
  version = "${modDirVersion}-ti-${tag}";
  inherit modDirVersion;

  src = fetchFromGitHub {
    owner = "beagleboard";
    repo = "linux";
    rev = "${version}";
    sha256 = "0dj0pzangdiiy4rs6hzyb647w5gpcxgsl5wjv3inbs6mrylj4zsk";
  };

  kernelPatches = args.kernelPatches;

  features = {
    efiBootStub = false;
  } // (args.features or {});

  extraMeta.hydraPlatforms = [ "armv7l-linux" ];
} // (args.argsOverride or {}))
