{ stdenv
, lib
, fetchFromGitHub
, ocamlPackages
, perlPackages
, elkhound
, which
, upx
, zip
}:

let

  ocaml = ocamlPackages.ocaml;
  platform = if stdenv.isDarwin then "Mac" else "Linux";
  zipTarget = if stdenv.isDarwin then "osx_zip" else "linux_zip";

  majorVersion = "246";
  minorVersion = "00";
  version = "${majorVersion}.${minorVersion}";

in
stdenv.mkDerivation {
  pname = "weidu";
  inherit version;

  src = fetchFromGitHub {
    owner = "WeiDUorg";
    repo = "weidu";
    rev = "v${version}";
    sha256 = "0c4i8mpk94plgkyi8dqlhkzbhd6nqfiaqm66zszk3m7n7zchcglk";
  };

  nativeBuildInputs = [ elkhound ocaml ];
  buildInputs = [ which upx zip ]
    ++ (with perlPackages; [ perl ])
    ++ (with ocamlPackages; [ ocaml ]);

  enableParallelBuilding = true;

  preConfigure = ''
    ln -s sample.Configuration Configuration
  '';

  prePatch = ''
    substituteInPlace Makefile.ocaml            --replace '$(OCAMLDIR)' '${ocaml}/bin'

    patchShebangs .
  '';

  installTargets = [ "weinstall" zipTarget ];
  postInstall = ''
    mkdir -p $out/bin
    cp ../WeiDU-${platform}/weidu $out/bin
    cp ../WeiDU-${platform}/weinstall $out/bin

    mkdir -p $out/share
    cp ../WeiDU-${platform}-${majorVersion}.zip $out/share
  '';

  meta = with lib; {
    description = "WeiDU is a program used to develop, distribute and install modifications for games based on the Infinity Engine.";
    license = with licenses; [ gpl2 ];
    homepage = https://github.com/WeiDUorg/weidu;
    maintainers = [maintainers.dhess-pers];
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}
