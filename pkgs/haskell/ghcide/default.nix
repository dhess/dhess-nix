{ mkDerivation, aeson, async, base, binary, bytestring, containers
, data-default, deepseq, directory, extra, fetchgit, filepath, ghc
, ghc-boot, ghc-boot-th, ghc-paths, ghc-typelits-knownnat, hashable
, haskell-lsp, haskell-lsp-types, hie-bios, hslogger, lens
, lsp-test, mtl, network-uri, optparse-applicative
, parser-combinators, prettyprinter, prettyprinter-ansi-terminal
, rope-utf16-splay, safe-exceptions, shake, sorted-list, stdenv
, stm, syb, tasty, tasty-expected-failure, tasty-hunit, text, time
, transformers, unix, unordered-containers, utf8-string
}:
mkDerivation {
  pname = "ghcide";
  version = "0.0.4";
  src = fetchgit {
    url = "https://github.com/digital-asset/ghcide.git";
    sha256 = "1w86jy44z45r2qfnsf2jz64vlp40d2sk0gc1xzl3f41kipajpgj2";
    rev = "78aa9745798cfd730861e8c037cc481aa6b0dd43";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson async base binary bytestring containers data-default deepseq
    directory extra filepath ghc ghc-boot ghc-boot-th hashable
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
    base bytestring containers directory extra filepath ghc
    ghc-typelits-knownnat haskell-lsp-types lens lsp-test
    parser-combinators tasty tasty-expected-failure tasty-hunit text
  ];
  homepage = "https://github.com/digital-asset/ghcide#readme";
  description = "The core of an IDE";
  license = stdenv.lib.licenses.asl20;
}
