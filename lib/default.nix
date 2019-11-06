let

  sources = import ../nix/sources.nix;

  fixedDhessLibNix =
  let
    try = builtins.tryEval <dhess_lib_nix>;
  in
    if try.success
      then builtins.trace "Using <dhess_lib_nix>" try.value
      else (import sources.dhess-lib-nix);

  dhess-lib-nix = fixedDhessLibNix {};
  inherit (dhess-lib-nix) lib haskell;
  inherit (lib.fetchers) fixedNixpkgs;
  inherit (lib.dhess-lib-nix) nixpkgs;

  fixedNixOps = lib.fetchers.fixedNixSrc "nixops" sources.nixops;

  fixedHpio = lib.fetchers.fixedNixSrc "hpio" sources.hpio;
  hpio = (import fixedHpio) {};

  fixedPinPon = lib.fetchers.fixedNixSrc "pinpon" sources.pinpon;
  pinpon = (import fixedPinPon) {};

  fixedMellon = lib.fetchers.fixedNixSrc "mellon" sources.mellon;
  mellon = (import fixedMellon) {};

  fixedAllHies = lib.fetchers.fixedNixSrc "all-hies" sources.all-hies;
  all-hies = (import fixedAllHies) {};

  fixedIHaskell = lib.fetchers.fixedNixSrc "IHaskell" sources.IHaskell;

  fixedLorri = lib.fetchers.fixedNixSrc "lorri" sources.lorri;

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

  inherit sources;
}
