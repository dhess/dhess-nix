let

  lib = import ../lib;
  inherit (lib) fixedNixpkgs;
  localPkgs = (import ../.) {};

in

{ supportedSystems ? [ "x86_64-darwin" ] # host platforms
, scrubJobs ? true
, nixpkgsArgs ? {
    config = { allowUnfree = true; allowBroken = true; inHydra = true; };
    overlays = lib.singleton localPkgs.overlays.all;
  }
}:

with import (fixedNixpkgs + "/pkgs/top-level/release-lib.nix") {
  inherit supportedSystems scrubJobs nixpkgsArgs;
};

let

  iOS = {
    config = "aarch64-apple-ios";
    sdkVer = "13.0";
    xcodeVer = "11.0";
    xcodePlatform = "iPhoneOS";
    useiOSPrebuilt = true;
    platform = {};
  };

  iOSJobs = (mapTestOnCross iOS {
    buildPackages.binutils = darwin;
  });

  jobs = iOSJobs // {
    ios = pkgs.releaseTools.aggregate {
      name = "dhess-nix-ios";
      meta.description = "dhess-nix packages cross-compiled for iOS.";
      meta.maintainer = lib.maintainers.dhess-pers;
      constituents = [
        iOSJobs.buildPackages.binutils.x86_64-darwin
      ];
    };
  };

in
jobs
