{ mkDerivation, base, containers, data-fix, dhall, fetchgit, hnix
, insert-ordered-containers, neat-interpolation, optparse-generic
, stdenv, text
}:
mkDerivation {
  pname = "dhall-nix";
  version = "1.1.6";
  src = fetchgit {
    url = "https://github.com/dhess/dhall-nix.git";
    sha256 = "1r8ix272gv083prlq5334gi3ivrkffwn2d4vnbrf3hx649zd9f75";
    rev = "ad6eee2990e343235a73548c4d0dde3fa4219a64";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base containers data-fix dhall hnix insert-ordered-containers
    neat-interpolation text
  ];
  executableHaskellDepends = [
    base dhall hnix optparse-generic text
  ];
  description = "Dhall to Nix compiler";
  license = stdenv.lib.licenses.bsd3;
}
