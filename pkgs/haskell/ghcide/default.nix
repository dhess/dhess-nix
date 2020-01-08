{ mkDerivation, aeson, async, base, binary, bytestring, containers
, data-default, deepseq, directory, extra, fetchgit, filepath
, fuzzy, ghc, ghc-boot, ghc-boot-th, ghc-paths
, ghc-typelits-knownnat, gitrev, hashable, haskell-lsp
, haskell-lsp-types, hie-bios, hslogger, lens, lsp-test, mtl
, network-uri, optparse-applicative, parser-combinators
, prettyprinter, prettyprinter-ansi-terminal, regex-tdfa
, rope-utf16-splay, safe-exceptions, shake, sorted-list, stdenv
, stm, syb, tasty, tasty-expected-failure, tasty-hunit, text, time
, transformers, unix, unordered-containers, utf8-string
}:
mkDerivation {
  pname = "ghcide";
  version = "0.0.5";
  src = fetchgit {
    url = "https://github.com/digital-asset/ghcide.git";
    sha256 = "0zngkkippi84yfp4ria1v5lh3a8cnlcnlk4m1wkp0p069i9l9zqz";
    rev = "db456b0e51bdec24f7ada0170ee08679de91020c";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson async base binary bytestring containers data-default deepseq
    directory extra filepath fuzzy ghc ghc-boot ghc-boot-th hashable
    haskell-lsp haskell-lsp-types hslogger mtl network-uri
    prettyprinter prettyprinter-ansi-terminal regex-tdfa
    rope-utf16-splay safe-exceptions shake sorted-list stm syb text
    time transformers unix unordered-containers utf8-string
  ];
  executableHaskellDepends = [
    base containers data-default directory extra filepath ghc ghc-paths
    gitrev haskell-lsp hie-bios hslogger optparse-applicative shake
    text
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
