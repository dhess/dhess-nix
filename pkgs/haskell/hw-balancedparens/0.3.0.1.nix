{ mkDerivation, base, criterion, deepseq, hedgehog, hspec
, hspec-discover, hw-bits, hw-excess, hw-fingertree
, hw-hspec-hedgehog, hw-prim, hw-rankselect-base, stdenv
, transformers, vector
}:
mkDerivation {
  pname = "hw-balancedparens";
  version = "0.3.0.1";
  sha256 = "5496a87bd7c9296bf974b239d3f7d4f878e39c5de8ae74523ab2ed155ca2cdd2";
  libraryHaskellDepends = [
    base deepseq hedgehog hspec hw-bits hw-excess hw-fingertree hw-prim
    hw-rankselect-base vector
  ];
  testHaskellDepends = [
    base hedgehog hspec hw-bits hw-hspec-hedgehog hw-prim
    hw-rankselect-base transformers vector
  ];
  testToolDepends = [ hspec-discover ];
  benchmarkHaskellDepends = [
    base criterion hedgehog hw-bits hw-prim vector
  ];
  doHaddock = false;
  homepage = "http://github.com/haskell-works/hw-balancedparens#readme";
  description = "Balanced parentheses";
  license = stdenv.lib.licenses.bsd3;
}
