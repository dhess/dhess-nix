{ mkDerivation, aeson, attoparsec, base, byteslice, bytesmith
, bytestring, criterion, deepseq, doctest, fetchgit, hashable
, hspec, hspec-discover, HUnit, natural-arithmetic, primitive
, QuickCheck, quickcheck-classes, small-bytearray-builder, stdenv
, tasty, tasty-hunit, tasty-quickcheck, text, text-short, vector
, wide-word
}:
mkDerivation {
  pname = "ip";
  version = "1.6.0";
  src = fetchgit {
    url = "https://github.com/andrewthad/haskell-ip";
    sha256 = "04rw9xqr3syrp885lhvl0a8af9k0xx45j6rfif7l6q3ri8h8vvcm";
    rev = "1f7de4b5c5a7d40182837315f0792815cd9f18ae";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    aeson attoparsec base byteslice bytesmith bytestring deepseq
    hashable natural-arithmetic primitive small-bytearray-builder text
    text-short vector wide-word
  ];
  testHaskellDepends = [
    attoparsec base byteslice bytestring doctest hspec HUnit QuickCheck
    quickcheck-classes tasty tasty-hunit tasty-quickcheck text
    text-short wide-word
  ];
  testToolDepends = [ hspec-discover ];
  benchmarkHaskellDepends = [
    attoparsec base byteslice bytestring criterion text
  ];
  homepage = "https://github.com/andrewthad/haskell-ip#readme";
  description = "Library for IP and MAC addresses";
  license = stdenv.lib.licenses.bsd3;
}
