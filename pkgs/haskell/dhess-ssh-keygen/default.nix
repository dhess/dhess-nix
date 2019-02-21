{ mkDerivation, base, base64-bytestring, bytestring, directory
, entropy, optparse-applicative, shelly, stdenv, system-filepath
, text, time, unix, fetchgit
}:
mkDerivation {
  pname = "dhess-ssh-keygen";
  version = "1.0.2";
  src = fetchgit {
    url = git://github.com/dhess/dhess-ssh-keygen;
    rev = "963526b1cd18ce5b2fa62da2d150769cbd54a0b4";
    sha256 = "01x8lkvxwg29rwna95v8pshp08nc8pj3giwhf88yfgnj6k64pics";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base base64-bytestring bytestring directory entropy
    optparse-applicative shelly system-filepath text time unix
  ];
  homepage = "https://github.com/dhess/dhess-ssh-keygen";
  description = "Enforce good ssh-keygen hygiene";
  license = stdenv.lib.licenses.bsd3;
}
