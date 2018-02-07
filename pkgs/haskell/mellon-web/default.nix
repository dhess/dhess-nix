{ mkDerivation, aeson, aeson-pretty, base, bytestring, doctest
, exceptions, hpio, hspec, hspec-wai, http-client, http-client-tls
, http-types, lens, lucid, mellon-core, mellon-gpio, mtl, network
, optparse-applicative, protolude, QuickCheck, quickcheck-instances
, servant, servant-client, servant-docs, servant-lucid
, servant-server, servant-swagger, servant-swagger-ui, stdenv
, swagger2, text, time, transformers, wai, wai-extra, warp
}:
mkDerivation {
  pname = "mellon-web";
  version = "0.8.0.6";
  sha256 = "e373922d0065988d05fded528c0b29a4213fe561881a5b147a6d26ebe613cb41";
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson aeson-pretty base bytestring http-client http-types lens
    lucid mellon-core protolude servant servant-client servant-docs
    servant-lucid servant-server servant-swagger servant-swagger-ui
    swagger2 text time transformers wai warp
  ];
  executableHaskellDepends = [
    base bytestring exceptions hpio http-client http-client-tls
    http-types mellon-core mellon-gpio mtl network optparse-applicative
    protolude servant-client time transformers warp
  ];
  testHaskellDepends = [
    aeson aeson-pretty base bytestring doctest hspec hspec-wai
    http-client http-types lens lucid mellon-core network protolude
    QuickCheck quickcheck-instances servant servant-client servant-docs
    servant-lucid servant-server servant-swagger servant-swagger-ui
    swagger2 text time transformers wai wai-extra warp
  ];
  homepage = "https://github.com/quixoftic/mellon#readme";
  description = "A REST web service for Mellon controllers";
  license = stdenv.lib.licenses.bsd3;
}
