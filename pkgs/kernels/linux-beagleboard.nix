{ stdenv, hostPlatform, fetchFromGitHub, perl, buildLinux, ... } @ args:

let
  localLib = import ../../lib.nix;
  modDirVersion = "4.14.12";
  tag = "r23";
in
import "${localLib.fetchNixPkgs}/pkgs/os-specific/linux/kernel/generic.nix" (args // rec {
  version = "${modDirVersion}-ti-${tag}";
  inherit modDirVersion;

  src = fetchFromGitHub {
    owner = "beagleboard";
    repo = "linux";
    rev = "${version}";
    sha256 = "0a8174i7i9dbbm535hwps52ah55rxvn8jyzrxw8w1fw4cny6l8ha";
  };

  kernelPatches = args.kernelPatches;

  features = {
    efiBootStub = false;
  } // (args.features or {});

  extraMeta.hydraPlatforms = [ "armv7l-linux" ];
} // (args.argsOverride or {}))
