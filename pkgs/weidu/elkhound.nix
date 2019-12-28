{ stdenv
, lib
, fetchFromGitHub
, cmake
, flex
, bison
, ocaml
}:

stdenv.mkDerivation rec {
  pname = "elkhound";
  version = "2019-08-25";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "WeiDUorg";
    repo = "elkhound";
    rev = version;
    sha256 = "1zvfv6ajicj572fvx9pj987fqx2rfrm1lvgkgc24pighk6q53fvb";
  };

  cmakeFlags = [ "../src" "-DEXTRAS=OFF" ];

  nativeBuildInputs = [ cmake flex bison ];
  buildInputs = [ ocaml ];

  dontInstall = true;
  preFixup = ''
    mkdir -p $out/bin
    cp elkhound/elkhound $out/bin/elkhound
  '';

  meta = with lib; {
    description = "Elkhound is a parser generator capable of emitting a GLR parser in OCaml.";
    homepage = https://github.com/WeiDUorg/elkhound;
    license = licenses.bsd3;
    maintainers = [maintainers.dhess-pers];
    platforms = platforms.unix;
  };
}

