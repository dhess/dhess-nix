{ mkDerivation, aeson, base, bytestring, data-default, deepseq
, filepath, hashable, lens, network-uri, scientific, stdenv, text
, unordered-containers
}:
mkDerivation {
  pname = "haskell-lsp-types";
  version = "0.18.0.0";
  sha256 = "387a97f8e02d6405cbbb30f87efea1cc09fe31cbd7925640a2ed3cd6fb1beafa";
  libraryHaskellDepends = [
    aeson base bytestring data-default deepseq filepath hashable lens
    network-uri scientific text unordered-containers
  ];
  homepage = "https://github.com/alanz/haskell-lsp";
  description = "Haskell library for the Microsoft Language Server Protocol, data types";
  license = stdenv.lib.licenses.mit;
}
