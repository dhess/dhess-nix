{ mkDerivation, base, hpio, mellon-core, protolude, stdenv }:
mkDerivation {
  pname = "mellon-gpio";
  version = "0.8.0.7";
  sha256 = "37c738cc6b0e9cdd781eec751d162b1aaefe4ed379acc9b1a3613440233ae841";
  libraryHaskellDepends = [ base hpio mellon-core protolude ];
  homepage = "https://github.com/quixoftic/mellon#readme";
  description = "GPIO support for mellon";
  license = stdenv.lib.licenses.bsd3;
}
