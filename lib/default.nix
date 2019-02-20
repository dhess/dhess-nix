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

  fixedHpio = lib.fetchers.fixedNixSrc "hpio_override" ./hpio-src.json;
  hpio = (import fixedHpio) {};

  fixedPinPon = lib.fetchers.fixedNixSrc "pinpon_override" ./pinpon-src.json;
  pinpon = (import fixedPinPon) {};

  fixedMellon = lib.fetchers.fixedNixSrc "mellon_override" ./mellon-src.json;
  mellon = (import fixedMellon) {};

  overlays = [
    dhess-lib-nix.overlays.all
    pinpon.overlays.pinpon
    mellon.overlays.mellon
    hpio.overlays.hpio
    (import ../overlays/custom-packages.nix)
    (import ../overlays/emacs.nix)
    (import ../overlays/haskell-packages.nix)
    (import ../overlays/lib.nix)
    (import ../overlays/overrides.nix)
    (import ../overlays/patches.nix)
  ];

in lib //
{
  inherit fixedNixpkgs;
  inherit nixpkgs;
  inherit haskell;
  inherit overlays;
}
