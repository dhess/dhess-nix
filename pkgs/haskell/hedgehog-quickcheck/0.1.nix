{ mkDerivation, base, hedgehog, QuickCheck, stdenv, transformers }:
mkDerivation {
  pname = "hedgehog-quickcheck";
  version = "0.1";
  sha256 = "610a5ccdfcdb4d657f5b25da622ad62562d1854ddb2e7381328e0b63a66f8412";
  revision = "3";
  editedCabalFile = "08pglka9hc7q3fql7fsmqn17wm1xmixkpqfslv86l79hn4y3rfq3";
  libraryHaskellDepends = [ base hedgehog QuickCheck transformers ];
  homepage = "https://hedgehog.qa";
  description = "Use QuickCheck generators in Hedgehog and vice versa";
  license = stdenv.lib.licenses.bsd3;
}
