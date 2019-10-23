let

  # From https://github.com/input-output-hk/iohk-ops/blob/e6f1ae95cdbfdd5c213aa0b9a1ef67150febc503/lib.nix
  
  fixedDhessLibNix =
  let
    try = builtins.tryEval <dhess_lib_nix>;
  in
    if try.success
      then builtins.trace "Using <dhess_lib_nix>" try.value
      else (import ./fetch-github.nix) { jsonSpec = builtins.readFile ./dhess-lib-nix-src.json; };

  dhess-lib-nix = (import fixedDhessLibNix) {};
  inherit (dhess-lib-nix) lib haskell;
  inherit (lib.fetchers) fixedNixpkgs;
  inherit (lib.dhess-lib-nix) nixpkgs;

  fixedNixOps = lib.fetchers.fixedNixSrc "nixops_override" ./nixops-src.json;

  fixedHpio = lib.fetchers.fixedNixSrc "hpio_override" ./hpio-src.json;
  hpio = (import fixedHpio) {};

  fixedPinPon = lib.fetchers.fixedNixSrc "pinpon_override" ./pinpon-src.json;
  pinpon = (import fixedPinPon) {};

  fixedMellon = lib.fetchers.fixedNixSrc "mellon_override" ./mellon-src.json;
  mellon = (import fixedMellon) {};

  fixedAllHies = lib.fetchers.fixedNixSrc "all_hies_override" ./all-hies-src.json;
  all-hies = (import fixedAllHies) {};

  fixedIHaskell = lib.fetchers.fixedNixSrc "ihaskell_override" ./ihaskell-src.json;

  fixedLorri = lib.fetchers.fixedNixSrc "lorri_override" ./lorri.json;

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
