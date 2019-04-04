{ mkDerivation, base, base16-bytestring, base64-bytestring, binary
, bytestring, containers, cryptohash-md5, cryptohash-sha1
, cryptohash-sha256, directory, fetchgit, filepath, hashable, mtl
, process, regex-base, regex-tdfa-text, saltine, stdenv, tasty
, tasty-discover, tasty-hspec, tasty-hunit, tasty-quickcheck
, temporary, text, time, unix, unordered-containers, vector
}:
mkDerivation {
  pname = "hnix-store-core";
  version = "0.2.0.0";
  src = fetchgit {
    url = "https://github.com/haskell-nix/hnix-store.git";
    sha256 = "1l8zai08cvj3ks8ypmwj9127cg3h20g30x4hywgplv4qbxgiyrk3";
    rev = "b6e9680437e6f80240b57eb5c106b6b1f08b865a";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/hnix-store-core; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base base16-bytestring binary bytestring containers cryptohash-md5
    cryptohash-sha1 cryptohash-sha256 directory filepath hashable mtl
    regex-base regex-tdfa-text saltine text time unix
    unordered-containers vector
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
