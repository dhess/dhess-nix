{ mkDerivation, aeson, aeson-pretty, base, bytestring, doctest
, exceptions, hlint, hpio, hspec, hspec-wai, http-client
, http-client-tls, http-types, lens, lucid, mellon-core
, mellon-gpio, mtl, network, optparse-applicative, QuickCheck
, quickcheck-instances, servant, servant-client, servant-docs
, servant-lucid, servant-server, servant-swagger
, servant-swagger-ui, stdenv, swagger2, text, time, transformers
, wai, wai-extra, warp
}:
mkDerivation {
  pname = "mellon-web";
  version = "0.8.0.3";
  sha256 = "d35ec4d5656dadf894e038edbfe68960662fdd685724e2b0b16aacc0d3315921";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson aeson-pretty base bytestring http-client http-types lens
    lucid mellon-core servant servant-client servant-docs servant-lucid
    servant-server servant-swagger servant-swagger-ui swagger2 text
    time transformers wai warp
  ];
  executableHaskellDepends = [
    base bytestring exceptions hpio http-client http-client-tls
    http-types mellon-core mellon-gpio mtl network optparse-applicative
    servant-client time transformers warp
  ];
  testHaskellDepends = [
    aeson aeson-pretty base bytestring doctest hlint hspec hspec-wai
    http-client http-types lens lucid mellon-core network QuickCheck
    quickcheck-instances servant servant-client servant-docs
    servant-lucid servant-server servant-swagger servant-swagger-ui
    swagger2 text time transformers wai wai-extra warp
  ];
  homepage = "https://github.com/quixoftic/mellon#readme";
  description = "A REST web service for Mellon controllers";
  license = stdenv.lib.licenses.bsd3;
}
