{ mkDerivation, aeson, aeson-pretty, base, bytestring, doctest
, exceptions, hpio, hspec, hspec-wai, http-client, http-client-tls
, http-types, lens, lucid, mellon-core, mellon-gpio, mtl, network
, optparse-applicative, protolude, QuickCheck, quickcheck-instances
, servant, servant-client, servant-client-core, servant-docs
, servant-lucid, servant-server, servant-swagger
, servant-swagger-ui, stdenv, swagger2, text, time, transformers
, wai, wai-extra, warp
}:
mkDerivation {
  pname = "mellon-web";
  version = "0.8.0.7";
  sha256 = "671c1ca0437b109a9f69cae0e5b8c3ac0f052e9d890a26de89f0731451826cd4";
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson aeson-pretty base bytestring http-client http-types lens
    lucid mellon-core protolude servant servant-client
    servant-client-core servant-docs servant-lucid servant-server
    servant-swagger servant-swagger-ui swagger2 text time transformers
    wai warp
  ];
  executableHaskellDepends = [
    base bytestring exceptions hpio http-client http-client-tls
    http-types mellon-core mellon-gpio mtl network optparse-applicative
    protolude servant-client servant-client-core time transformers warp
  ];
  testHaskellDepends = [
    aeson aeson-pretty base bytestring doctest hspec hspec-wai
    http-client http-types lens lucid mellon-core network protolude
    QuickCheck quickcheck-instances servant servant-client
    servant-client-core servant-docs servant-lucid servant-server
    servant-swagger servant-swagger-ui swagger2 text time transformers
    wai wai-extra warp
  ];
  homepage = "https://github.com/quixoftic/mellon#readme";
  description = "A REST web service for Mellon controllers";
  license = stdenv.lib.licenses.bsd3;
}
