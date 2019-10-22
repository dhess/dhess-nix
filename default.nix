let

  lib = import ./lib;
  defaultPkgs = lib.nixpkgs { config = { allowBroken = true; allowUnfree = true; }; };

in

{ pkgs ? defaultPkgs }:

let

  overlays = self: super:
    lib.customisation.composeOverlays lib.overlays super;
  self = lib.customisation.composeOverlays (lib.singleton overlays) pkgs;

in
{
  inherit (self) aws-vault;

  inherit (self) badhosts-unified;
  inherit (self) badhosts-fakenews badhosts-gambling badhosts-porn badhosts-social;
  inherit (self) badhosts-fakenews-gambling badhosts-fakenews-porn badhosts-fakenews-social;
  inherit (self) badhosts-gambling-porn badhosts-gambling-social;
  inherit (self) badhosts-porn-social;
  inherit (self) badhosts-fakenews-gambling-porn badhosts-fakenews-gambling-social;
  inherit (self) badhosts-fakenews-porn-social;
  inherit (self) badhosts-gambling-porn-social;
  inherit (self) badhosts-fakenews-gambling-porn-social;
  inherit (self) badhosts-all;

  inherit (self) ccextractor;
  inherit (self) cfssl;
  inherit (self) crosstool-ng-xtensa;
  inherit (self) debian-ppp;
  inherit (self) dhess-ssh-keygen;
  inherit (self) ffmpeg-full;
  inherit (self) fm-assistant;
  inherit (self) gawk_4_2_1;
  inherit (self) hydra;
  inherit (self) ipxe;
  inherit (self) libprelude;
  inherit (self) mellon-gpio mellon-web;
  inherit (self) mkCacert;
  inherit (self) nixops;
  inherit (self) ntp;
  inherit (self) pinpon;
  inherit (self) ppp-devel;
  inherit (self) unbound;
  inherit (self) suricata;
  inherit (self) terraform-provider-vultr;
  inherit (self) trimpcap;
  inherit (self) tsoff;
  inherit (self) wpa_supplicant;
  inherit (self) xtensa-esp32-toolchain;

  inherit (self) dhallToNixFromFile dhallToNixFromSrc;
  inherit (self) hello-dhall-file hello-dhall-src;
  inherit (self) hashedCertDir;

  inherit (self) emacsMelpaPackagesNg;
  inherit (self) emacs-nox emacsNoXMelpaPackagesNg;
  inherit (self) emacsMacportMelpaPackagesNg;
  inherit (self) emacs-env emacs-nox-env emacs-macport-env;

  inherit (self) haskellPackages;
  inherit (self) coreHaskellPackages;
  inherit (self) extensiveHaskellPackages;
  inherit (self) mkHaskellBuildEnv;
  inherit (self) haskell-env;
  inherit (self) extensive-haskell-env;
  inherit (self) all-hies;

  inherit (self) hyperkit;
  inherit (self) minikube;

  inherit (self) ihaskell;
  inherit (self) ihaskell-env;
  inherit (self) ihaskell-envfun;
  inherit (self) extensive-ihaskell-env;
  inherit (self) extensive-ihaskell-envfun;

  inherit (self) python-env;

  inherit (self) darwin;
  inherit (self) xcode xcode_11_0;

  # Various buildEnv's that I use, usually only on macOS (though many
  # of them should work on any pltform).
  inherit (self) mactools-env;
  inherit (self) maths-env;
  inherit (self) minikube-env;
  inherit (self) nixops-env;
  inherit (self) nixtools-env;
  inherit (self) opsec-env;
  inherit (self) shell-env;

  inherit (self) dhess-nix-source;

  inherit (self) lib;

  overlays.all = overlays;
}
