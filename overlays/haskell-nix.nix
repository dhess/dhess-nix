self: super:

let

  lib = import ../lib;

  inherit (super) callPackage;

  haskell-nix-pkgs = (import lib.fixedNixpkgs) (import lib.fixedHaskellNix);

in
{
  inherit (haskell-nix-pkgs) haskell-nix;
  inherit (haskell-nix-pkgs.haskell-nix) nix-tools;
}
