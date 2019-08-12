{ mkDerivation, base, containers, data-fix, dhall, fetchgit, hnix
, neat-interpolation, optparse-generic, stdenv, text
}:
mkDerivation {
  pname = "dhall-nix";
  version = "1.1.7";
  src = fetchgit {
    url = "https://github.com/dhall-lang/dhall-haskell.git";
    sha256 = "1drzjvayqj1kyycgqib6vls476r3d6ridv55ga429madhlj2dmnm";
    rev = "d45f3ec46b4b791705de0352f7ce382260845171";
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
