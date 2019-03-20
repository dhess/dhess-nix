{ mkDerivation, aeson, base, bytestring, directory, doctest
, fetchgit, filepath, stdenv
}:
mkDerivation {
  pname = "doctest-discover";
  version = "0.2.0.0";
  src = fetchgit {
    url = "https://github.com/karun012/doctest-discover.git";
    sha256 = "183y363x3q2qw7abmwwvmh7qdi3bxq9ai8hz2zk5zpnkwin02ha9";
    rev = "9334e8e35205b670869881034db86fd0e688bb3d";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base bytestring directory doctest filepath
  ];
  executableHaskellDepends = [
    aeson base bytestring directory doctest filepath
  ];
  testHaskellDepends = [ base doctest ];
  doHaddock = false;
  homepage = "http://github.com/karun012/doctest-discover";
  description = "Easy way to run doctests via cabal";
  license = stdenv.lib.licenses.publicDomain;
}
