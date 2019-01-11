{ mkDerivation, aeson, aeson-pretty, base, base64-bytestring
, binary, blaze-html, blaze-markup, bytestring, Cabal
, case-insensitive, cmark-gfm, containers, criterion, data-default
, deepseq, Diff, directory, doctemplates, exceptions
, executable-path, filepath, Glob, haddock-library, hslua
, hslua-module-text, HsYAML, HTTP, http-client, http-client-tls
, http-types, JuicyPixels, mtl, network, network-uri, pandoc-types
, parsec, process, QuickCheck, random, safe, SHA, skylighting
, split, stdenv, syb, tagsoup, tasty, tasty-golden, tasty-hunit
, tasty-quickcheck, temporary, texmath, text, time
, unicode-transforms, unix, unordered-containers, vector, weigh
, xml, zip-archive, zlib
}:
mkDerivation {
  pname = "pandoc";
  version = "2.4";
  sha256 = "9389cff66f9fef73000ba0e8d0a721e9328b4e5b8dafc2618805bae8fed9c1cd";
  configureFlags = [ "-fhttps" "-f-trypandoc" ];
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  setupHaskellDepends = [ base Cabal ];
  libraryHaskellDepends = [
    aeson aeson-pretty base base64-bytestring binary blaze-html
    blaze-markup bytestring case-insensitive cmark-gfm containers
    data-default deepseq directory doctemplates exceptions filepath
    Glob haddock-library hslua hslua-module-text HsYAML HTTP
    http-client http-client-tls http-types JuicyPixels mtl network
    network-uri pandoc-types parsec process random safe SHA skylighting
    split syb tagsoup temporary texmath text time unicode-transforms
    unix unordered-containers vector xml zip-archive zlib
  ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [
    base base64-bytestring bytestring containers Diff directory
    executable-path filepath Glob hslua pandoc-types process QuickCheck
    tasty tasty-golden tasty-hunit tasty-quickcheck temporary text time
    xml zip-archive
  ];
  benchmarkHaskellDepends = [
    base bytestring containers criterion mtl text time weigh
  ];
  doCheck = false;
  homepage = "https://pandoc.org";
  description = "Conversion between markup formats";
  license = stdenv.lib.licenses.gpl2;
}
