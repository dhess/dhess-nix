{ mkDerivation, async, base, doctest, hspec, mtl, protolude
, QuickCheck, quickcheck-instances, stdenv, time, transformers
}:
mkDerivation {
  pname = "mellon-core";
  version = "0.8.0.7";
  sha256 = "380d2e710d9909968e17a541dfae1b3e1ed272c72cd1f78111c30452ebc498da";
  libraryHaskellDepends = [
    async base mtl protolude time transformers
  ];
  testHaskellDepends = [
    async base doctest hspec mtl protolude QuickCheck
    quickcheck-instances time transformers
  ];
  homepage = "https://github.com/quixoftic/mellon#readme";
  description = "Control physical access devices";
  license = stdenv.lib.licenses.bsd3;
}
