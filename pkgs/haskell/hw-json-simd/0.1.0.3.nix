{ mkDerivation, base, bytestring, c2hs, hw-prim, lens
, optparse-applicative, stdenv, vector
}:
mkDerivation {
  pname = "hw-json-simd";
  version = "0.1.0.3";
  sha256 = "543ec70c7e905af6d137dfc79adb92de300ed72e21d084b929fd8fce003ef131";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base bytestring hw-prim lens vector ];
  libraryToolDepends = [ c2hs ];
  executableHaskellDepends = [
    base bytestring hw-prim lens optparse-applicative vector
  ];
  testHaskellDepends = [ base bytestring hw-prim lens vector ];
  homepage = "https://github.com/haskell-works/hw-json-simd#readme";
  description = "SIMD-based JSON semi-indexer";
  license = stdenv.lib.licenses.bsd3;
}
