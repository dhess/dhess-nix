self: super:

let

  inherit (self.haskell.lib) doJailbreak dontCheck;

  dhall-to-cabal-packages = self.haskell.lib.properExtend super.haskellPackages (self: super:
    {
      # dhall runs network tests.
      dhall = dontCheck (doJailbreak (super.callPackage ../pkgs/haskell/dhall/1.18.0.nix {}));
      dhall-to-cabal = doJailbreak (super.callPackage ../pkgs/haskell/dhall-to-cabal {});
    }
  );

  dhall-nix-packages = self.haskell.lib.properExtend super.haskell.packages.ghc844 (self: super:
    {
      cereal = dontCheck super.cereal;
      Diff = dontCheck super.Diff;
    }
  );

in
{
  ## Executables only.

  mellon-gpio = self.haskell.lib.justStaticExecutables self.haskellPackages.mellon-gpio;
  mellon-web = self.haskell.lib.justStaticExecutables self.haskellPackages.mellon-web;

  # Disable tests on the static executable; something in the doctests
  # causes a nasty (internal?) GHC bug.
  pinpon = self.haskell.lib.justStaticExecutables (self.haskell.lib.dontCheck self.haskellPackages.pinpon);

  dhall-to-cabal = self.haskell.lib.justStaticExecutables dhall-to-cabal-packages.dhall-to-cabal;
  dhall-nix = self.haskell.lib.justStaticExecutables dhall-nix-packages.dhall-nix;
}
