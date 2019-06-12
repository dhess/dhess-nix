{ mkDerivation, base, containers, data-fix, dhall, fetchgit, hnix
, neat-interpolation, optparse-generic, stdenv, text
}:
mkDerivation {
  pname = "dhall-nix";
  version = "1.1.7";
  src = fetchgit {
    url = "https://github.com/dhall-lang/dhall-haskell.git";
    sha256 = "0x630v0x3jwj5kiwyk177slwgcj92fpviwx55wplg7dc559g3s58";
    rev = "d77a9f4e43f475b2d22c0ff1fbb70bff130bb54c";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/dhall-nix; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base containers data-fix dhall hnix neat-interpolation text
  ];
  executableHaskellDepends = [
    base dhall hnix optparse-generic text
  ];
  description = "Dhall to Nix compiler";
  license = stdenv.lib.licenses.bsd3;
}
