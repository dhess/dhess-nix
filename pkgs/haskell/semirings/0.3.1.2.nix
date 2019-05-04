{ mkDerivation, base, containers, hashable, integer-gmp, stdenv
, unordered-containers, vector
}:
mkDerivation {
  pname = "semirings";
  version = "0.3.1.2";
  sha256 = "c1082e5a26b78b13e6d9d7326343c34994ce34a5097200d800adc51eea7305fe";
  libraryHaskellDepends = [
    base containers hashable integer-gmp unordered-containers vector
  ];
  homepage = "http://github.com/chessai/semirings";
  description = "two monoids as one, in holy haskimony";
  license = stdenv.lib.licenses.bsd3;
}
