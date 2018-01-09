self: super:

let

  inherit (super) pkgs;
  inherit (pkgs) haskell;

  hp = if pkgs.stdenv.isArm then super.haskell.packages.ghc802 else super.haskellPackages;

in rec {

  haskellPackages =
  with haskell.lib;
  hp.extend (self: super:
    {
      pinpon = dontCheck
        (self.callPackage ../pkgs/haskell/pinpon {});
    });

  pinpon = haskell.lib.justStaticExecutables haskellPackages.pinpon;

}
