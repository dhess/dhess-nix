{ mkDerivation, aeson, aeson-pretty, amazonka, amazonka-core
, amazonka-sns, base, bytestring, containers, doctest, exceptions
, hpio, http-client, http-client-tls, http-types, lens, lucid, mtl
, network, optparse-applicative, optparse-text, protolude
, resourcet, servant, servant-client, servant-docs, servant-lucid
, servant-server, servant-swagger, servant-swagger-ui, stdenv
, swagger2, text, time, transformers, transformers-base, wai, warp
}:
mkDerivation {
  pname = "pinpon";
  version = "0.2.0.2";
  sha256 = "ba574558403ce27566bed01cdbb2f84a4fc0f47511a6c359bf0be8507ffd8dbb";
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson aeson-pretty amazonka amazonka-core amazonka-sns base
    bytestring containers exceptions http-client http-types lens lucid
    mtl protolude resourcet servant servant-client servant-docs
    servant-lucid servant-server servant-swagger servant-swagger-ui
    swagger2 text time transformers transformers-base wai warp
  ];
  executableHaskellDepends = [
    amazonka amazonka-sns base bytestring containers exceptions hpio
    http-client http-client-tls http-types lens mtl network
    optparse-applicative optparse-text protolude servant-client text
    time transformers warp
  ];
  testHaskellDepends = [ base doctest protolude ];
  homepage = "https://github.com/quixoftic/pinpon#readme";
  description = "A gateway for various cloud notification services";
  license = stdenv.lib.licenses.bsd3;
}
