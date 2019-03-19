{ mkDerivation, base, Cabal, conduit, conduit-extra, directory
, exceptions, fetchgit, filepath, ghc, haddock-api, http-types, mtl
, optparse-applicative, process, resourcet, sqlite-simple, stdenv
, tagsoup, text, transformers
}:
mkDerivation {
  pname = "haddocset";
  version = "0.4.3";
  src = fetchgit {
    url = "https://github.com/dhess/haddocset.git";
    sha256 = "1a2yyb24v3hhan53f7sv4i23f2vh3pw7cd4yjs4hb3p86p32ikmh";
    rev = "bcd34e23b128852758e1a07dc27e105b25ab0c82";
    fetchSubmodules = true;
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base Cabal conduit conduit-extra directory exceptions filepath ghc
    haddock-api http-types mtl optparse-applicative process resourcet
    sqlite-simple tagsoup text transformers
  ];
  homepage = "https://github.com/philopon/haddocset";
  description = "Generate docset of Dash by Haddock haskell documentation tool";
  license = stdenv.lib.licenses.bsd3;
}
