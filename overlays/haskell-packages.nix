self: super:

let

  inherit (self.pkgs) haskell;
  inherit (self) lib;
  inherit (super.pkgs.stdenv) isArm;

  hp = if isArm then haskell.packages.ghc802 else super.haskellPackages;

in
{

  haskellPackages =
  with haskell.lib;
  hp.extend (self: super:
    {

      hpio = self.callPackage ../pkgs/haskell/hpio {};

      pinpon = self.callPackage ../pkgs/haskell/pinpon {};

      # Needed by pinpon on ghc-8.0.2 (for armv7l).
      concurrent-output = if isArm then doJailbreak super.concurrent-output
                                   else super.concurrent-output;
      hedgehog = if isArm then dontCheck super.hedgehog
                          else super.hedgehog;

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
