{ mkDerivation, async, base, doctest, hlint, hspec, mtl, QuickCheck
, quickcheck-instances, stdenv, time, transformers
}:
mkDerivation {
  pname = "mellon-core";
  version = "0.8.0.3";
  sha256 = "edaf4d5653a2b4302511edb7a5f1e73d14686b7c69df8d05bf724b0ad874f981";
  libraryHaskellDepends = [ async base mtl time transformers ];
  testHaskellDepends = [
    async base doctest hlint hspec mtl QuickCheck quickcheck-instances
    time transformers
  ];
  homepage = "https://github.com/quixoftic/mellon#readme";
  description = "Control physical access devices";
  license = stdenv.lib.licenses.bsd3;
}
