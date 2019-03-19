{ mkDerivation, base, base16-bytestring, base64-bytestring, binary
, bytestring, containers, cryptohash-md5, cryptohash-sha1
, cryptohash-sha256, directory, fetchgit, filepath, hashable, mtl
, process, regex-base, regex-tdfa-text, stdenv, tasty
, tasty-discover, tasty-hspec, tasty-hunit, tasty-quickcheck
, temporary, text, unix, unordered-containers, vector
}:
mkDerivation {
  pname = "hnix-store-core";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/haskell-nix/hnix-store.git";
    sha256 = "1z48msfkiys432rkd00fgimjgspp98dci11kgg3v8ddf4mk1s8g0";
    rev = "0f50f40ffb9f992b950407c4512b01c7d059e819";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/hnix-store-core; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base base16-bytestring binary bytestring containers cryptohash-md5
    cryptohash-sha1 cryptohash-sha256 directory filepath hashable mtl
    regex-base regex-tdfa-text text unix unordered-containers vector
  ];
  testHaskellDepends = [
    base base64-bytestring binary bytestring containers directory
    process tasty tasty-discover tasty-hspec tasty-hunit
    tasty-quickcheck temporary text
  ];
  testToolDepends = [ tasty-discover ];
  homepage = "https://github.com/haskell-nix/hnix-store";
  description = "Core effects for interacting with the Nix store";
  license = stdenv.lib.licenses.asl20;
}
