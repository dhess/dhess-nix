{ mkDerivation, base, constraints, containers, dlist, exceptions
, fetchgit, generic-lens, hspec, lens, monad-control, monad-unlift
, mtl, mutable-containers, primitive, safe-exceptions, silently
, stdenv, streaming, temporary, text, transformers, unliftio
, unliftio-core
}:
mkDerivation {
  pname = "capability";
  version = "0.2.0.0";
  src = fetchgit {
    url = "https://github.com/tweag/capability";
    sha256 = "04sgdm9b1pl7awa2z1aljr48llq519z2v2qp11np2bzsjca76nan";
    rev = "a87e62d649557c3276319ef4ce5459e2be8f840e";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    base constraints dlist exceptions generic-lens lens monad-control
    monad-unlift mtl mutable-containers primitive safe-exceptions
    streaming transformers unliftio unliftio-core
  ];
  testHaskellDepends = [
    base containers hspec lens mtl silently streaming temporary text
    unliftio
  ];
  homepage = "https://github.com/tweag/capability";
  description = "Extensional capabilities and deriving combinators";
  license = stdenv.lib.licenses.bsd3;
}
