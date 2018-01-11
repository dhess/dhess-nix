self: super:

let

  inherit (super) pkgs;
  inherit (pkgs) haskell;
  inherit (self) lib;

  hp = if pkgs.stdenv.isArm then super.haskell.packages.ghc802 else super.haskellPackages;

in rec {

  haskellPackages =
  with haskell.lib;
  hp.extend (self: super:
    {
      pinpon = dontCheck
        (self.callPackage ../pkgs/haskell/pinpon {});


      ## These packages are already in Nixpkgs, but their
      ## hydraPlatforms is "none". I want to build them in Hydra, so
      ## we override just that attribute.
      ##
      ## (Note: currently disabled as I had to update mellon-* on
      ## Hackage, so until that's reflected in nixpkgs, we actually do
      ## override these locally.

      # mellon-core = super.mellon-core.overrideAttrs (oldAttrs: {
      #   meta.hydraPlatforms = lib.platforms.all;
      # });
      # mellon-gpio = super.mellon-gpio.overrideAttrs (oldAttrs: {
      #   meta.hydraPlatforms = lib.platforms.all;
      # });
      # mellon-web = super.mellon-web.overrideAttrs (oldAttrs: {
      #   meta.hydraPlatforms = lib.platforms.all;
      # });

      mellon-core = dontCheck (self.callPackage ../pkgs/haskell/mellon-core {});
      mellon-gpio = dontCheck (self.callPackage ../pkgs/haskell/mellon-gpio {});
      mellon-web = dontCheck (self.callPackage ../pkgs/haskell/mellon-web {});

    });

  ## Executables only.

  mellon-gpio = haskell.lib.justStaticExecutables haskellPackages.mellon-gpio;
  mellon-web = haskell.lib.justStaticExecutables haskellPackages.mellon-web;
  pinpon = haskell.lib.justStaticExecutables haskellPackages.pinpon;

}
