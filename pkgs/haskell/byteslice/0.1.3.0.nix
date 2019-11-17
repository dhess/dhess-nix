{ mkDerivation, base, primitive, primitive-addr, run-st, stdenv
, tasty, tasty-hunit, tasty-quickcheck
}:
mkDerivation {
  pname = "byteslice";
  version = "0.1.3.0";
  sha256 = "ee7107add9325ccba80c574a4eaca47bb047f1f3a68374f407e21ea6d84da653";
  libraryHaskellDepends = [ base primitive primitive-addr run-st ];
  testHaskellDepends = [
    base primitive tasty tasty-hunit tasty-quickcheck
  ];
  homepage = "https://github.com/andrewthad/byteslice";
  description = "Slicing managed and unmanaged memory";
  license = stdenv.lib.licenses.bsd3;
}
