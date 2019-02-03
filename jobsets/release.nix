let

  lib = import ../lib.nix;
  fixedNixPkgs = lib.fetchNixPkgs;
  packageSet = (import fixedNixPkgs);

in

{ supportedSystems ? [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" ]
, scrubJobs ? true
, nixpkgsArgs ? {
    config = { allowUnfree = false; inHydra = true; };
    overlays = [ (import ../.) ];
  }
}:

with import (fixedNixPkgs + "/pkgs/top-level/release-lib.nix") {
  inherit supportedSystems scrubJobs nixpkgsArgs packageSet;
};

let

  x86_64 = [ "x86_64-linux" "x86_64-darwin" ];
  x86_64_linux = [ "x86_64-linux" ];
  linux = [ "x86_64-linux" "aarch64-linux" ];

  jobs = (mapTestOn (rec {
    crosstool-ng-xtensa = x86_64;
    darcs = all;
    debian-ppp = linux;
    dhall-nix = all;
    dhall-to-cabal = all;
    hydra = x86_64_linux;
    libprelude = x86_64_linux;
    netsniff-ng = x86_64_linux;
    nix_2_1_3 = all;
    ntp = linux;
    suricata = x86_64_linux;
    trimpcap = linux;
    tsoff = linux;
    unbound = linux;
    unbound-block-hosts = all;
    wpa_supplicant = linux;
    xtensa-esp32-toolchain = x86_64;
    emacs-nox = linux;
    emacs-nox-env = linux;
    emacs-macport-env = darwin;
    haskell-env = all;
    extensive-haskell-env = all;
    pinpon = all;
    mellon-gpio = all;
    mellon-web = all;

    ## These aren't really part of the overlay, but we test them
    ## here anyway as we're the upstream.

    haskellPackages.pinpon = all;
    haskellPackages.hpio = all;
    haskellPackages.mellon-core = all;
    haskellPackages.mellon-gpio = all;
    haskellPackages.mellon-web = all;
  })) // (rec {
    x86_64-linux = pkgs.releaseTools.aggregate {
      name = "nixpkgs-quixoftic-x86_64-linux";
      meta.description = "nixpkgs-quixoftic overlay packages (x86_64-linux)";
      meta.maintainer = lib.maintainers.dhess-pers;
      constituents = with jobs; [
        crosstool-ng-xtensa.x86_64-linux
        darcs.x86_64-linux
        debian-ppp.x86_64-linux
        dhall-nix.x86_64-linux
        dhall-to-cabal.x86_64-linux
        hydra.x86_64-linux
        libprelude.x86_64-linux
        netsniff-ng.x86_64-linux
        nix_2_1_3.x86_64-linux
        ntp.x86_64-linux
        suricata.x86_64-linux
        trimpcap.x86_64-linux
        tsoff.x86_64-linux
        unbound.x86_64-linux
        unbound-block-hosts.x86_64-linux
        wpa_supplicant.x86_64-linux
        xtensa-esp32-toolchain.x86_64-linux

        emacs-nox-env.x86_64-linux
        haskell-env.x86_64-linux
        extensive-haskell-env.x86_64-linux

        ## These aren't really part of the overlay (except possibly to
        ## enable Hydra builds on them), but we test them here anyway
        ## as we're the upstream.
        
        haskellPackages.pinpon.x86_64-linux
        haskellPackages.hpio.x86_64-linux
        haskellPackages.mellon-core.x86_64-linux
        haskellPackages.mellon-gpio.x86_64-linux
        haskellPackages.mellon-web.x86_64-linux
      ];
    };

    x86_64-darwin = pkgs.releaseTools.aggregate {
      name = "nixpkgs-quixoftic-x86_64-darwin";
      meta.description = "nixpkgs-quixoftic overlay packages (x86_64-darwin)";
      meta.maintainer = lib.maintainers.dhess-pers;
      constituents = with jobs; [
        crosstool-ng-xtensa.x86_64-darwin
        darcs.x86_64-darwin
        dhall-nix.x86_64-darwin
        dhall-to-cabal.x86_64-darwin
        unbound-block-hosts.x86_64-darwin
        xtensa-esp32-toolchain.x86_64-darwin

        emacs-macport-env.x86_64-darwin
        haskell-env.x86_64-darwin
        extensive-haskell-env.x86_64-darwin

        ## These aren't really part of the overlay (except possibly to
        ## enable Hydra builds on them), but we test them here anyway
        ## as we're the upstream.
        
        haskellPackages.pinpon.x86_64-darwin
        haskellPackages.hpio.x86_64-darwin
        haskellPackages.mellon-core.x86_64-darwin
        haskellPackages.mellon-gpio.x86_64-darwin
        haskellPackages.mellon-web.x86_64-darwin
      ];
    };

    aarch64-linux = pkgs.releaseTools.aggregate {
      name = "nixpkgs-quixoftic-aarch64-linux";
      meta.description = "nixpkgs-quixoftic overlay packages (aarch64-linux)";
      meta.maintainer = lib.maintainers.dhess-pers;
      constituents = with jobs; [
        ntp.aarch64-linux
        unbound.aarch64-linux

        emacs-nox-env.aarch64-linux
        haskell-env.aarch64-linux
        #extensive-haskell-env.aarch64-linux

        ## These aren't really part of the overlay (except possibly to
        ## enable Hydra builds on them), but we test them here anyway
        ## as we're the upstream.

        haskellPackages.pinpon.aarch64-linux
        haskellPackages.hpio.aarch64-linux
        haskellPackages.mellon-core.aarch64-linux
        haskellPackages.mellon-gpio.aarch64-linux
        haskellPackages.mellon-web.aarch64-linux
      ];
    };
  });

in
jobs
