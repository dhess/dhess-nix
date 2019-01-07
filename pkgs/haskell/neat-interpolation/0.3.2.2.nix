{ mkDerivation, base, base-prelude, HTF, megaparsec, stdenv
, template-haskell, text
}:
mkDerivation {
  pname = "neat-interpolation";
  version = "0.3.2.2";
  sha256 = "b6c8c5eca58ee99f9528ff21386ffa8e7dbc2e02186824cbaf74d795b0c9cc39";
  libraryHaskellDepends = [
    base base-prelude megaparsec template-haskell text
  ];
  testHaskellDepends = [ base-prelude HTF ];
  homepage = "https://github.com/nikita-volkov/neat-interpolation";
  description = "A quasiquoter for neat and simple multiline text interpolation";
  license = stdenv.lib.licenses.mit;
}
