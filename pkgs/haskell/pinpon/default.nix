{ mkDerivation, aeson, aeson-pretty, amazonka, amazonka-core
, amazonka-sns, base, bytestring, containers, doctest, exceptions
, fetchgit, hpio, http-client, http-client-tls, http-types, lens
, lucid, mtl, network, optparse-applicative, optparse-text
, protolude, resourcet, servant, servant-client
, servant-client-core, servant-docs, servant-lucid, servant-server
, servant-swagger, servant-swagger-ui, stdenv, swagger2, text, time
, transformers, transformers-base, wai, warp
}:
mkDerivation {
  pname = "pinpon";
  version = "0.2.0.2";
  src = fetchgit {
    url = "https://github.com/quixoftic/pinpon.git";
    sha256 = "0l1wyj1vk5hxs7qg6w1hvs0ysrf6i4gyhhzzxqf4ks19nkzmpmc9";
    rev = "de17f511ff80e5a3e8c5608b1f06199d277708a7";
  };
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson aeson-pretty amazonka amazonka-core amazonka-sns base
    bytestring containers exceptions http-client http-types lens lucid
    mtl protolude resourcet servant servant-client servant-client-core
    servant-docs servant-lucid servant-server servant-swagger
    servant-swagger-ui swagger2 text time transformers
    transformers-base wai warp
  ];
  executableHaskellDepends = [
    amazonka amazonka-sns base bytestring containers exceptions hpio
    http-client http-client-tls http-types lens mtl network
    optparse-applicative optparse-text protolude servant-client
    servant-client-core text time transformers warp
  ];
  testHaskellDepends = [ base doctest protolude ];
  homepage = "https://github.com/quixoftic/pinpon#readme";
  description = "A gateway for various cloud notification services";
  license = stdenv.lib.licenses.bsd3;
}
