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
  version = "4.12.5.1";
  src = fetchgit {
    url = "https://github.com/jaspervdj/hakyll.git";
    sha256 = "1mkvf3kiq9c6dm9wir9sv07vk1ckf61nqd6k1i5s8ifkwxhjhp62";
    rev = "79a3368c0d0b7c49810aabb188965c0f749616db";
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
  jailbreak = true;
  homepage = "http://jaspervdj.be/hakyll";
  description = "A static website compiler library";
  license = stdenv.lib.licenses.bsd3;
}
