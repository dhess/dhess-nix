self: super:

let

  lib = import ../lib;

  inherit (super) callPackage;

  haskell-nix-attrs = (import lib.fixedHaskellNix);
  haskell-nix-pkgs = (import lib.fixedNixpkgs) { inherit (haskell-nix-attrs) config overlays; };

in
{
  inherit (haskell-nix-pkgs) haskell-nix;
  inherit (haskell-nix-pkgs.haskell-nix) nix-tools;
}
