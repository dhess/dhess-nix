{ mkDerivation, base, bytestring, fetchgit, primitive
, primitive-addr, run-st, stdenv, tasty, tasty-hunit
, tasty-quickcheck
}:
mkDerivation {
  pname = "byteslice";
  version = "0.2.0.0";
  src = fetchgit {
    url = "https://github.com/andrewthad/byteslice";
    sha256 = "0axrcx6qivn7x3qlb7z4flsmv73i025f30d1mh52rcz3whp6dzc4";
    rev = "7f0b7d04c000c07f48c330e5ed855b746b759741";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [ base primitive primitive-addr run-st ];
  testHaskellDepends = [
    base bytestring primitive tasty tasty-hunit tasty-quickcheck
  ];
  homepage = "https://github.com/andrewthad/byteslice";
  description = "Slicing managed and unmanaged memory";
  license = stdenv.lib.licenses.bsd3;
}
