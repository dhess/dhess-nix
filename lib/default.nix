let

  sources = import ../nix/sources.nix;

  dhess-lib-nix = (import sources.dhess-lib-nix) {};
  inherit (dhess-lib-nix) lib haskell;
  inherit (lib.fetchers) fixedNixpkgs;
  inherit (lib.dhess-lib-nix) nixpkgs;

  fixedNixOps = sources.nixops;

  fixedHpio = sources.hpio;
  hpio = (import fixedHpio) {};

  fixedPinPon = sources.pinpon;
  pinpon = (import fixedPinPon) {};

  fixedMellon = sources.mellon;
  mellon = (import fixedMellon) {};

  fixedAllHies = sources.all-hies;
  all-hies = (import fixedAllHies) {};

  fixedIHaskell = sources.IHaskell;

  fixedLorri = sources.lorri;

  overlays = [
    dhess-lib-nix.overlays.all
    pinpon.overlays.pinpon
    mellon.overlays.mellon
    hpio.overlays.hpio
  ] ++ (map import [
    ../overlays/apple.nix
    ../overlays/custom-packages.nix
    ../overlays/emacs.nix
    ../overlays/haskell-packages.nix
    ../overlays/lib/dhess-lib.nix
    ../overlays/lib/types.nix
    ../overlays/overrides.nix
    ../overlays/patches.nix
    ../overlays/python.nix
    ../overlays/build-support.nix
    ../overlays/build-envs.nix
  ]);

in lib //
{
  inherit fixedNixpkgs;
  inherit nixpkgs;
  inherit haskell;
  inherit overlays;
  inherit fixedAllHies all-hies;
  inherit fixedNixOps;
  inherit fixedIHaskell;
  inherit fixedLorri;
}
