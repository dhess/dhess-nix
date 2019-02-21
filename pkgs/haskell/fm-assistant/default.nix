{ mkDerivation, base, bytestring, cond, containers, directory
, doctest, exceptions, fetchgit, filepath, foldl, hspec, lens, lzma, mtl
, optparse-applicative, path, path-io, process-streaming, resourcet
, stdenv, streaming, streaming-bytestring, system-filepath, tar
, template-haskell, temporary, text, time, transformers, unrar
}:
mkDerivation {
  pname = "fm-assistant";
  version = "0.6.0.0";
  src = fetchgit {
    url = git://github.com/dhess/fm-assistant;
    rev = "5bdff9732c8ccbe99982f779737070d2d4fc87cd";
    sha256 = "0iyf3yj57f9cg2d07qnwrbz061gid37dbmj6sfvj26i6lwnz9mhg";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base bytestring cond containers directory exceptions filepath foldl
    lens lzma mtl path path-io process-streaming resourcet streaming
    streaming-bytestring system-filepath tar template-haskell temporary
    text time transformers
  ];
  executableHaskellDepends = [
    base bytestring cond containers directory exceptions filepath foldl
    lens lzma mtl optparse-applicative path path-io process-streaming
    resourcet streaming streaming-bytestring system-filepath tar
    template-haskell temporary text time transformers unrar
  ];
  testHaskellDepends = [
    base bytestring cond containers directory doctest exceptions
    filepath foldl hspec lens lzma mtl path path-io process-streaming
    resourcet streaming streaming-bytestring system-filepath tar
    template-haskell temporary text time transformers
  ];
  license = stdenv.lib.licenses.bsd3;
}
