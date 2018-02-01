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

      # Until upgraded by upstream.
      hpio = super.hpio_0_9_0_4.overrideAttrs (oldAttrs: {
        meta.hydraPlatforms = lib.platforms.all;
      });

    });

  ## Executables only.

  mellon-gpio = haskell.lib.justStaticExecutables self.haskellPackages.mellon-gpio;
  mellon-web = haskell.lib.justStaticExecutables self.haskellPackages.mellon-web;
  pinpon = haskell.lib.justStaticExecutables self.haskellPackages.pinpon;

}
