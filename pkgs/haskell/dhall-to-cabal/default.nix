{ mkDerivation, base, bytestring, Cabal, containers, contravariant
, dhall, Diff, directory, fetchgit, filepath, hashable, microlens
, optparse-applicative, prettyprinter, stdenv, tasty, tasty-golden
, tasty-hunit, text, transformers, vector
}:
mkDerivation {
  pname = "dhall-to-cabal";
  version = "1.3.1.0";
  src = fetchgit {
    url = "https://github.com/dhall-lang/dhall-to-cabal.git";
    sha256 = "0dbxm7xqc4cc2lvl6wh08wrzxw1xy3gk9f8dgric4j4y7s05clys";
    rev = "bcb8dab2d6ab8a22f8591e8080085fd77a5737eb";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base bytestring Cabal containers contravariant dhall hashable text
    transformers vector
  ];
  executableHaskellDepends = [
    base bytestring Cabal dhall directory filepath microlens
    optparse-applicative prettyprinter text transformers
  ];
  testHaskellDepends = [
    base bytestring Cabal dhall Diff filepath microlens prettyprinter
    tasty tasty-golden tasty-hunit text
  ];
  homepage = "https://github.com/ocharles/dhall-to-cabal";
  description = "Compile Dhall expressions to Cabal files";
  license = stdenv.lib.licenses.mit;
}
