self: super:

let

  inherit (self.pkgs) haskell;
  inherit (self) lib;

  hp = if super.pkgs.stdenv.isArm then haskell.packages.ghc802 else super.haskellPackages;

in
{

  haskellPackages =
  with haskell.lib;
  hp.extend (self: super:
    {

      hpio = self.callPackage ../pkgs/haskell/hpio {};

      pinpon = self.callPackage ../pkgs/haskell/pinpon {};

      mellon-core = self.callPackage ../pkgs/haskell/mellon-core {};
      mellon-gpio = self.callPackage ../pkgs/haskell/mellon-gpio {};
      mellon-web = self.callPackage ../pkgs/haskell/mellon-web {};

    });

  ## Executables only.

  mellon-gpio = haskell.lib.justStaticExecutables self.haskellPackages.mellon-gpio;
  mellon-web = haskell.lib.justStaticExecutables self.haskellPackages.mellon-web;
  pinpon = haskell.lib.justStaticExecutables self.haskellPackages.pinpon;

}
