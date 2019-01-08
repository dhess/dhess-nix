self: super:

let

  inherit (super) stdenv;
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
      # Needs to be called with flags for GHC 8.4.4.
      aeson = doJailbreak (super.callPackage ../pkgs/haskell/aeson {});

      cereal = dontCheck super.cereal;
      dhall = dontCheck (doJailbreak (super.callPackage ../pkgs/haskell/dhall/1.17.0.nix {}));
      dhall-nix = super.dhall-nix.overrideAttrs (drv: {
        meta.hydraPlatforms = stdenv.lib.platforms.all;
      });
      Diff = dontCheck super.Diff;
      insert-ordered-containers = doJailbreak super.insert-ordered-containers;
      megaparsec = dontCheck (super.callPackage ../pkgs/haskell/megaparsec/6.5.0.nix {});
      neat-interpolation = super.callPackage ../pkgs/haskell/neat-interpolation/0.3.2.2.nix {};
      repline = super.callPackage ../pkgs/haskell/repline/0.1.7.0.nix {};
      these = doJailbreak super.these;
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
