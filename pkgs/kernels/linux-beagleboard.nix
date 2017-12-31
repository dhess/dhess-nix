{ stdenv, hostPlatform, fetchFromGitHub, perl, buildLinux, ... } @ args:

let
  localLib = import ../../lib.nix;
  modDirVersion = "4.9.69";
  tag = "r86";
in
import "${localLib.fetchNixPkgs}/pkgs/os-specific/linux/kernel/generic.nix" (args // rec {
  version = "${modDirVersion}-ti-${tag}";
  inherit modDirVersion;

  src = fetchFromGitHub {
    owner = "beagleboard";
    repo = "linux";
    rev = "${version}";
    sha256 = "1sh6kricdrl3670w7l65085jw7kk502z2ha4aii9nfdj2g5qznqg";
  };

  kernelPatches = args.kernelPatches;

  features = {
    efiBootStub = false;
  } // (args.features or {});

  extraMeta.hydraPlatforms = [ "armv7l-linux" ];
} // (args.argsOverride or {}))
