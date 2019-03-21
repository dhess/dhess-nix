{ mkDerivation, aeson, attoparsec, base, bytestring, criterion
, deepseq, doctest, hashable, hspec, hspec-discover, HUnit
, primitive, QuickCheck, quickcheck-classes, stdenv, test-framework
, test-framework-hunit, test-framework-quickcheck2, text, vector
}:
mkDerivation {
  pname = "ip";
  version = "1.4.2.1";
  sha256 = "41c92e12ba99adc31d1d2113909ae85784d9f0bb42ff054f4252b4b79e5fc118";
  libraryHaskellDepends = [
    aeson attoparsec base bytestring deepseq hashable primitive text
    vector
  ];
  testHaskellDepends = [
    attoparsec base bytestring doctest hspec HUnit QuickCheck
    quickcheck-classes test-framework test-framework-hunit
    test-framework-quickcheck2 text
  ];
  testToolDepends = [ hspec-discover ];
  benchmarkHaskellDepends = [
    attoparsec base bytestring criterion text
  ];
  homepage = "https://github.com/andrewthad/haskell-ip#readme";
  description = "Library for IP and MAC addresses";
  license = stdenv.lib.licenses.bsd3;
}
