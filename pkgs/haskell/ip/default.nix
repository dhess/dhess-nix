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
    url = "https://github.com/hackworthltd/haskell-ip";
    sha256 = "0q6w8kxss0ym8wnlrm28amr1xbl4w2hx9i3fpr280vqq2qcywm92";
    rev = "cc49f2fc85a2e4a7181f0c709d398f00b9318d3a";
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
