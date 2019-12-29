{ mkDerivation, aeson, async, base, binary, bytestring, containers
, data-default, deepseq, directory, extra, fetchgit, filepath
, fuzzy, ghc, ghc-boot, ghc-boot-th, ghc-paths
, ghc-typelits-knownnat, hashable, haskell-lsp, haskell-lsp-types
, hie-bios, hslogger, lens, lsp-test, mtl, network-uri
, optparse-applicative, parser-combinators, prettyprinter
, prettyprinter-ansi-terminal, rope-utf16-splay, safe-exceptions
, shake, sorted-list, stdenv, stm, syb, tasty
, tasty-expected-failure, tasty-hunit, text, time, transformers
, unix, unordered-containers, utf8-string
}:
mkDerivation {
  pname = "ghcide";
  version = "0.0.5";
  src = fetchgit {
    url = "https://github.com/digital-asset/ghcide.git";
    sha256 = "0kmhal32y1l6gyi0r4kfhmv3wwx2rsqrvk0zd626kn9jhl1318sn";
    rev = "359cdf5b24043cff4d56bf10759817caa95e9b8f";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson async base binary bytestring containers data-default deepseq
    directory extra filepath fuzzy ghc ghc-boot ghc-boot-th hashable
    haskell-lsp haskell-lsp-types hslogger mtl network-uri
    prettyprinter prettyprinter-ansi-terminal rope-utf16-splay
    safe-exceptions shake sorted-list stm syb text time transformers
    unix unordered-containers utf8-string
  ];
  executableHaskellDepends = [
    base containers data-default directory extra filepath ghc ghc-paths
    haskell-lsp hie-bios hslogger optparse-applicative shake text
  ];
  testHaskellDepends = [
    aeson base bytestring containers directory extra filepath ghc
    ghc-typelits-knownnat haskell-lsp-types lens lsp-test
    parser-combinators tasty tasty-expected-failure tasty-hunit text
  ];
  homepage = "https://github.com/digital-asset/ghcide#readme";
  description = "The core of an IDE";
  license = stdenv.lib.licenses.asl20;
}
