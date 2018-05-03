self: super:

let

  inherit (self.pkgs) haskell;
  inherit (self) lib;
  inherit (super.pkgs.stdenv) isAarch32;

  hp = if isAarch32 then haskell.packages.ghc802 else super.haskellPackages;

in
{
  ## Executables only.

  mellon-gpio = haskell.lib.justStaticExecutables self.haskellPackages.mellon-gpio;
  mellon-web = haskell.lib.justStaticExecutables self.haskellPackages.mellon-web;

  # Disable tests on the static executable; something in the doctests
  # causes a nasty (internal?) GHC bug.

  pinpon = haskell.lib.justStaticExecutables (haskell.lib.dontCheck self.haskellPackages.pinpon);

}
