self: super:

let

  inherit (super) pkgs;
  inherit (pkgs) haskell;

in rec {

  haskellPackages =
  with haskell.lib;
  super.haskellPackages.extend (self: super:
    {
      pinpon = dontCheck
        (self.callPackage ../pkgs/haskell/pinpon {});
    });

  pinpon = haskell.lib.justStaticExecutables haskellPackages.pinpon;

}
