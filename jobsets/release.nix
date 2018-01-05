let

  lib = import ../lib.nix;
  fixedNixPkgs = lib.fetchNixPkgs;
  packageSet = (import fixedNixPkgs);

in

{ supportedSystems ? [ "x86_64-linux" "armv7l-linux" "aarch64-linux" ]
, scrubJobs ? true
, nixpkgsArgs ? {
    config = { allowUnfree = false; inHydra = true; };
    overlays = [ (import ../.) ];
  }
}:

with import ./release-lib.nix {
  inherit lib supportedSystems scrubJobs nixpkgsArgs packageSet;
};

let

  jobs = {

    x86_64-linux = pkgs.releaseTools.aggregate {
      name = "nixpkgs-quixoftic-x86_64-linux";
      meta.description = "nixpkgs-quixoftic overlay packages (x86_64-linux)";
      meta.maintainer = lib.maintainers.dhess;
      constituents = with jobs; [
        ffmpeg-snapshot.x86_64-linux
        gitaly.x86_64-linux
        haskellPackages.pinpon.x86_64-linux
        hyperscan.x86_64-linux
        libnet_1_1.x86_64-linux
        libprelude.x86_64-linux
        netsniff-ng.x86_64-linux
        pinpon.x86_64-linux
        suricata.x86_64-linux
        trimpcap.x86_64-linux
        tsoff.x86_64-linux
        unbound-block-hosts.x86_64-linux
      ];
    };

    armv7l-linux = pkgs.releaseTools.aggregate {
      name = "nixpkgs-quixoftic-armv7l-linux";
      meta.description = "nixpkgs-quixoftic overlay packages (armv7l-linux)";
      meta.maintainer = lib.maintainers.dhess;
      constituents = with jobs; [
        #bb-org-overlays.armv7l-linux
        haskellPackages.pinpon.armv7l-linux
        #linux_beagleboard.armv7l-linux
        pinpon.armv7l-linux
      ];
    };

    aarch64-linux = pkgs.releaseTools.aggregate {
      name = "nixpkgs-quixoftic-aarch64-linux";
      meta.description = "nixpkgs-quixoftic overlay packages (aarch64-linux)";
      meta.maintainer = lib.maintainers.dhess;
      constituents = with jobs; [
        haskellPackages.pinpon.aarch64-linux
        pinpon.aarch64-linux
      ];
    };

  } // (mapTestOn ((packagePlatforms pkgs) // rec {
    haskell.compiler = packagePlatforms pkgs.haskell.compiler;
    haskellPackages = packagePlatforms pkgs.haskellPackages;
  }));

in
{
  # Disable while we concentrate on armv7l-linux GHC.
  #inherit (jobs) x86_64-linux;
  inherit (jobs) armv7l-linux;

  # Doesn't evaluate yet due to GHC issues.
  #inherit (jobs) aarch64-linux;
}
