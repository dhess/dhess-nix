self: super:

let

  inherit (self.pkgs) haskell;
  inherit (self) lib;
  inherit (super.pkgs.stdenv) isAarch32;

  hp = if isAarch32 then haskell.packages.ghc802 else super.haskellPackages;

in
{

  haskellPackages =
  with haskell.lib;
  hp.extend (self: super:
    {

      hpio = self.callPackage ../pkgs/haskell/hpio {};

      pinpon = self.callPackage ../pkgs/haskell/pinpon {};

      # Needed for pinpon.
      conduit = super.conduit_1_2_13_1;
      conduit-extra = super.conduit-extra_1_2_3_2;
      http-conduit = super.http-conduit_2_2_4;
      resourcet = super.resourcet_1_1_11;
      xml-conduit = super.xml-conduit_1_7_1_2;

      mellon-core = self.callPackage ../pkgs/haskell/mellon-core {};
      mellon-gpio = self.callPackage ../pkgs/haskell/mellon-gpio {};
      mellon-web = self.callPackage ../pkgs/haskell/mellon-web {};

    });

  ## Executables only.

  mellon-gpio = haskell.lib.justStaticExecutables self.haskellPackages.mellon-gpio;
  mellon-web = haskell.lib.justStaticExecutables self.haskellPackages.mellon-web;

  # Disable tests on the static executable; something in the doctests
  # causes a nasty (internal?) GHC bug.

  pinpon = haskell.lib.justStaticExecutables (haskell.lib.dontCheck self.haskellPackages.pinpon);

}
