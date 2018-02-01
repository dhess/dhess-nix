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

  ## Aggregates are handy for defining jobs (especially for subsets of
  ## platforms), but they don't provide very useful information in
  ## Hydra, especially when they die. We use aggregates here to define
  ## set of jobs, and then splat them into the output attrset so that
  ## they're more visible in Hydra.

  enumerateConstituents = aggregate: lib.listToAttrs (
    map (d:
           let
             name = (builtins.parseDrvName d.name).name;
             system = d.system;
           in
             { name = name + "." + system;
               value = d;
             }
         )
        aggregate.constituents
  );

  jobs = {

    x86_64-linux = pkgs.releaseTools.aggregate {
      name = "nixpkgs-quixoftic-x86_64-linux";
      meta.description = "nixpkgs-quixoftic overlay packages (x86_64-linux)";
      meta.maintainer = lib.maintainers.dhess-qx;
      constituents = with jobs; [
        ffmpeg-snapshot.x86_64-linux
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

        ## These aren't really part of the overlay (except possibly to
        ## enable Hydra builds on them), but we test them here anyway
        ## as we're the upstream.
        
        haskellPackages.hpio.x86_64-linux
        haskellPackages.mellon-core.x86_64-linux
        haskellPackages.mellon-gpio.x86_64-linux
        haskellPackages.mellon-web.x86_64-linux
        mellon-gpio.x86_64-linux
        mellon-web.x86_64-linux
      ];
    };

    armv7l-linux = pkgs.releaseTools.aggregate {
      name = "nixpkgs-quixoftic-armv7l-linux";
      meta.description = "nixpkgs-quixoftic overlay packages (armv7l-linux)";
      meta.maintainer = lib.maintainers.dhess-qx;
      constituents = with jobs; [
        bb-org-overlays.armv7l-linux
        haskellPackages.pinpon.armv7l-linux
        linux_beagleboard.armv7l-linux
        pinpon.armv7l-linux

        ## These aren't really part of the overlay (except possibly to
        ## enable Hydra builds on them), but we test them here anyway
        ## as we're the upstream.
        
        haskellPackages.hpio.armv7l-linux
        haskellPackages.mellon-core.armv7l-linux
        haskellPackages.mellon-gpio.armv7l-linux
        haskellPackages.mellon-web.armv7l-linux
        mellon-gpio.armv7l-linux
        mellon-web.armv7l-linux
      ];
    };

    aarch64-linux = pkgs.releaseTools.aggregate {
      name = "nixpkgs-quixoftic-aarch64-linux";
      meta.description = "nixpkgs-quixoftic overlay packages (aarch64-linux)";
      meta.maintainer = lib.maintainers.dhess-qx;
      constituents = with jobs; [
        #haskellPackages.pinpon.aarch64-linux
        #pinpon.aarch64-linux
      ];
    };

  } // (mapTestOn ((packagePlatforms pkgs) // rec {
    haskell.compiler = packagePlatforms pkgs.haskell.compiler;
    haskellPackages = packagePlatforms pkgs.haskellPackages;
  }));

in
{
  inherit (jobs) x86_64-linux;
  inherit (jobs) armv7l-linux;
  inherit (jobs) aarch64-linux;
}
// enumerateConstituents jobs.x86_64-linux
// enumerateConstituents jobs.armv7l-linux
// enumerateConstituents jobs.aarch64-linux
