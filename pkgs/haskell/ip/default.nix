{ mkDerivation, aeson, attoparsec, base, bytestring, criterion
, deepseq, doctest, fetchgit, hashable, hspec, hspec-discover
, HUnit, primitive, QuickCheck, quickcheck-classes, stdenv
, test-framework, test-framework-hunit, test-framework-quickcheck2
, text, vector, wide-word
}:
mkDerivation {
  pname = "ip";
  version = "1.5.0";
  src = fetchgit {
    url = "https://github.com/andrewthad/haskell-ip.git";
    sha256 = "0d4pjb8si8rlj3b7vqcjjj15a7anw5glqr9pc32khxd9igvkv3gs";
    rev = "0742cd48f5a49a0e8718f6eb559c70d5192ac799";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    aeson attoparsec base bytestring deepseq hashable primitive text
    vector wide-word
  ];
  testHaskellDepends = [
    attoparsec base bytestring doctest hspec HUnit QuickCheck
    quickcheck-classes test-framework test-framework-hunit
    test-framework-quickcheck2 text wide-word
  ];
  testToolDepends = [ hspec-discover ];
  benchmarkHaskellDepends = [
    attoparsec base bytestring criterion text
  ];
  homepage = "https://github.com/andrewthad/haskell-ip#readme";
  description = "Library for IP and MAC addresses";
  license = stdenv.lib.licenses.bsd3;
}
