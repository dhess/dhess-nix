{ mkDerivation, base, hedgehog, stdenv, tagged, tasty
, tasty-expected-failure
}:
mkDerivation {
  pname = "tasty-hedgehog";
  version = "1.0.0.1";
  sha256 = "1ff66a01a74f8ae992eba6a3434b3eebc5914cbcc048772d99d975c0002e6fd5";
  revision = "2";
  editedCabalFile = "0zrp7njdx69pvhf1lg4fv3p962qfsm2z3qk09h0jhxmfj5ishnhs";
  libraryHaskellDepends = [ base hedgehog tagged tasty ];
  testHaskellDepends = [
    base hedgehog tasty tasty-expected-failure
  ];
  homepage = "https://github.com/qfpl/tasty-hedgehog";
  description = "Integration for tasty and hedgehog";
  license = stdenv.lib.licenses.bsd3;
}
