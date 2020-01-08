{ mkDerivation, aeson, async, base-noprelude, binary, clay, cmdargs
, containers, directory, exceptions, fetchgit, foldl, fsnotify
, lucid, megaparsec, mmark, mmark-ext, modern-uri, mtl, pandoc
, pandoc-include-code, pandoc-types, path, path-io, relude, shake
, stdenv, text, wai, wai-app-static, warp
}:
mkDerivation {
  pname = "rib";
  version = "0.6.0.0";
  src = fetchgit {
    url = "https://github.com/srid/rib.git";
    sha256 = "1viyvaigqh0vgawl2z1jmxg4iy0s4hac8xsjahinqryvzx3n0lb6";
    rev = "f6e3f68a91d9f208552210a13cc27e2927680787";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    aeson async base-noprelude binary clay cmdargs containers directory
    exceptions foldl fsnotify lucid megaparsec mmark mmark-ext
    modern-uri mtl pandoc pandoc-include-code pandoc-types path path-io
    relude shake text wai wai-app-static warp
  ];
  homepage = "https://github.com/srid/rib#readme";
  description = "Static site generator using Shake";
  license = stdenv.lib.licenses.bsd3;
}
