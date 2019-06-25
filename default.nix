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
  inherit (self) crosstool-ng-xtensa;
  inherit (self) debian-ppp;
  inherit (self) dhall-nix;
  inherit (self) dhess-ssh-keygen;
  inherit (self) fm-assistant;
  inherit (self) hydra;
  inherit (self) ipxe;
  inherit (self) libprelude;
  inherit (self) lz4;
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

  inherit (self) dhallToNix dhallToNixFromFile dhallToNixFromSrc;
  inherit (self) hello-dhall-file hello-dhall-src;

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

  inherit (self) python-env;

  # Various buildEnv's that I use, usually only on macOS (though many
  # of them should work on any pltform).
  inherit (self) mactools-env;
  inherit (self) maths-env;
  inherit (self) nixops-env;
  inherit (self) nixtools-env;
  inherit (self) opsec-env;
  inherit (self) shell-env;

  inherit (self) dhess-nix-source;

  inherit (self) lib;

  overlays.all = overlays;
}
