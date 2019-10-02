{ mkDerivation, base, bytestring, criterion, directory, exceptions
, ghc-prim, hedgehog, hspec, hspec-discover, hw-hspec-hedgehog
, mmap, QuickCheck, semigroups, stdenv, transformers, unliftio-core
, vector
}:
mkDerivation {
  pname = "hw-prim";
  version = "0.6.2.35";
  sha256 = "0ef7868653ee18b047b145af0897a71b31ceaff27e63e4eed60ba826665da13a";
  libraryHaskellDepends = [
    base bytestring ghc-prim mmap semigroups transformers unliftio-core
    vector
  ];
  testHaskellDepends = [
    base bytestring directory exceptions hedgehog hspec
    hw-hspec-hedgehog mmap QuickCheck semigroups transformers vector
  ];
  testToolDepends = [ hspec-discover ];
  benchmarkHaskellDepends = [
    base bytestring criterion mmap semigroups transformers vector
  ];
  homepage = "http://github.com/haskell-works/hw-prim#readme";
  description = "Primitive functions and data types";
  license = stdenv.lib.licenses.bsd3;
}
