{ stdenv, buildPackages, hostPlatform, fetchFromGitHub, perl, buildLinux, ubootTools, dtc, ... } @ args:

let

  localLib = import ../../lib.nix;
  generic = import "${localLib.fetchNixPkgs}/pkgs/os-specific/linux/kernel/generic.nix";
  modDirVersion = "4.14.17";
  tag = "r32";

in
stdenv.lib.overrideDerivation (buildLinux (args // rec {
  version = "${modDirVersion}-ti-${tag}";
  inherit modDirVersion;

  src = fetchFromGitHub {
    owner = "beagleboard";
    repo = "linux";
    rev = "${version}";
    sha256 = "06l5f7lv6rlblvhcwnp37yklj961cd23hrrcpzr4043qsnk9zs47";
  };

  kernelPatches = args.kernelPatches;

  features = {
    efiBootStub = false;
  } // (args.features or {});

  extraMeta.hydraPlatforms = [ "armv7l-linux" ];
} // (args.argsOverride or {}))) (oldAttrs: {

  # This kernel will run mkuboot.sh.
  postPatch = ''
    patchShebangs scripts/
  '';

  nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ dtc ubootTools ];

})
