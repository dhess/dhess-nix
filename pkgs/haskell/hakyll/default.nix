{ mkDerivation, base, binary, blaze-html, blaze-markup, bytestring
, containers, cryptohash, data-default, deepseq, directory
, fetchgit, file-embed, filepath, fsnotify, http-conduit
, http-types, lrucache, mtl, network-uri, optparse-applicative
, pandoc, pandoc-citeproc, parsec, process, QuickCheck, random
, regex-tdfa, resourcet, scientific, stdenv, tagsoup, tasty
, tasty-hunit, tasty-quickcheck, text, time, time-locale-compat
, unordered-containers, utillinux, vector, wai, wai-app-static
, warp, yaml
}:
mkDerivation {
  pname = "hakyll";
  version = "4.12.4.0";
  src = fetchgit {
    url = "https://github.com/jaspervdj/hakyll.git";
    sha256 = "1f8kkjwyas1fbvk5912yvk1k17wvnb64l5h1v2srqd0jyr9afpvw";
    rev = "87fb74183f71f7befe7a0c9227c68368ce465703";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    base binary blaze-html blaze-markup bytestring containers
    cryptohash data-default deepseq directory file-embed filepath
    fsnotify http-conduit http-types lrucache mtl network-uri
    optparse-applicative pandoc pandoc-citeproc parsec process random
    regex-tdfa resourcet scientific tagsoup text time
    time-locale-compat unordered-containers vector wai wai-app-static
    warp yaml
  ];
  executableHaskellDepends = [ base directory filepath ];
  testHaskellDepends = [
    base bytestring containers filepath QuickCheck tasty tasty-hunit
    tasty-quickcheck text unordered-containers yaml
  ];
  testToolDepends = [ utillinux ];
  homepage = "http://jaspervdj.be/hakyll";
  description = "A static website compiler library";
  license = stdenv.lib.licenses.bsd3;
}
