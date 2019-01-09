self: super:

let

  inherit (super) stdenv;
  inherit (super.haskell.lib) doJailbreak dontCheck properExtend;

  exeOnly = super.haskell.lib.justStaticExecutables;

  ## Haskell package fixes for various versions of GHC, based on the
  ## current nixpkgs snapshot that we're using.

  # The current GHC.

  haskellPackages = properExtend super.haskellPackages (self: super:
    {
    }
  );

  # GHC 8.4.4.

  ghc844Packages = properExtend super.haskell.packages.ghc844 (self: super:
    {
      Diff = dontCheck super.Diff;

      # Needs to be called with flags for GHC 8.4.4.
      aeson = doJailbreak (super.callPackage ../pkgs/haskell/aeson {});

      cereal = dontCheck super.cereal;

      darcs = doJailbreak (super.darcs.overrideAttrs (drv: {
        meta.hydraPlatforms = stdenv.lib.platforms.all;
      }));

      insert-ordered-containers = doJailbreak super.insert-ordered-containers;
      these = doJailbreak super.these;
    }
  );


  ## Custom package sets for things that need particular package versions.

  dhall-to-cabal-packages = properExtend super.haskellPackages (self: super:
    {
      # dhall runs network tests.
      dhall = dontCheck (doJailbreak (super.callPackage ../pkgs/haskell/dhall/1.18.0.nix {}));

      dhall-to-cabal = doJailbreak (super.callPackage ../pkgs/haskell/dhall-to-cabal {});
    }
  );

  dhall-nix-packages = properExtend ghc844Packages (self: super:
    {
      # dhall runs network tests.
      dhall = dontCheck (doJailbreak (super.callPackage ../pkgs/haskell/dhall/1.17.0.nix {}));

      dhall-nix = super.dhall-nix.overrideAttrs (drv: {
        meta.hydraPlatforms = stdenv.lib.platforms.all;
      });

      megaparsec = dontCheck (super.callPackage ../pkgs/haskell/megaparsec/6.5.0.nix {});

      neat-interpolation = super.callPackage ../pkgs/haskell/neat-interpolation/0.3.2.2.nix {};

      repline = super.callPackage ../pkgs/haskell/repline/0.1.7.0.nix {};
    }
  );

in
{
  inherit haskellPackages;

  ## Executables only.

  darcs = exeOnly ghc844Packages.darcs;

  dhall-nix = exeOnly dhall-nix-packages.dhall-nix;

  dhall-to-cabal = exeOnly dhall-to-cabal-packages.dhall-to-cabal;

  mellon-gpio = exeOnly self.haskellPackages.mellon-gpio;

  mellon-web = exeOnly self.haskellPackages.mellon-web;

  # Disable tests on the static executable; something in the doctests
  # causes a nasty (internal?) GHC bug.
  pinpon = exeOnly (self.haskellPackages.pinpon);
}
