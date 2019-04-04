{ mkDerivation, base, containers, data-fix, dhall, fetchgit, hnix
, insert-ordered-containers, neat-interpolation, optparse-generic
, stdenv, text
}:
mkDerivation {
  pname = "dhall-nix";
  version = "1.1.6";
  src = fetchgit {
    url = "https://github.com/Profpatsch/dhall-nix.git";
    sha256 = "1kdsbnj681lf65dsdclcrzj4cab1hh0v22n2140386zvwmawyp6r";
    rev = "feae0ce5b2ecf4daeeae15c39f427f126c33da7c";
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
