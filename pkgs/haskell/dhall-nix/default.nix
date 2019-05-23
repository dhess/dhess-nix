{ mkDerivation, base, containers, data-fix, dhall, fetchgit, hnix
, neat-interpolation, optparse-generic, stdenv, text
}:
mkDerivation {
  pname = "dhall-nix";
  version = "1.1.7";
  src = fetchgit {
    url = "https://github.com/dhall-lang/dhall-haskell";
    sha256 = "1nyyxz3n12vdfawlghpj9vs5a24594zvqxfv10lflgkabjsmi6mm";
    rev = "bf4349ef7acf66779c244ffd2af78cdacc6e754b";
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
