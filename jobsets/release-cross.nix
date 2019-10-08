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

  iPhoneOS = {
    config = "aarch64-apple-ios";
    sdkVer = "13.1";
    xcodeVer = "11.1";
    xcodePlatform = "iPhoneOS";
    useiOSPrebuilt = true;
    platform = {};
  };

  iPhoneOSJobs = (mapTestOnCross iPhoneOS {
    buildPackages.binutils = darwin;
  });

  jobs = iPhoneOSJobs // {
    ios-iphone = pkgs.releaseTools.aggregate {
      name = "dhess-nix-ios-iphone";
      meta.description = "dhess-nix packages cross-compiled for iOS on the iPhone.";
      meta.maintainer = lib.maintainers.dhess-pers;
      constituents = [
        iPhoneOSJobs.buildPackages.binutils.x86_64-darwin
      ];
    };
  };

in
jobs
