{ mkDerivation, base, containers, haskeline, mtl, process, stdenv
}:
mkDerivation {
  pname = "repline";
  version = "0.1.7.0";
  sha256 = "503a035d8a380ac21c532e48c0f47006ff1c20ed9683f4906fdb304b4b9e55de";
  libraryHaskellDepends = [ base containers haskeline mtl process ];
  homepage = "https://github.com/sdiehl/repline";
  description = "Haskeline wrapper for GHCi-like REPL interfaces";
  license = stdenv.lib.licenses.mit;
}
