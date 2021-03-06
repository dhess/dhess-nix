{ stdenv
, lib
, source
, buildGoModule
, libiconv
, libusb1
, pkgconfig
}:

buildGoModule rec {
  pname = "aws-okta";
  version = source.version;

  goPackagePath = "github.com/segmentio/aws-okta";
  modSha256 = "1aqhifj8mwhmph3hyvljkdl6gmyyr42aawx9ih0akswz12ypkji7";

  src = source.outPath;

  buildFlags = "--tags release";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libusb1 libiconv ];

  meta = with lib; {
    description = "aws-vault like tool for Okta authentication";
    license = licenses.mit;
    maintainers = [ maintainers.dhess-pers ];
    platforms = platforms.all;
    homepage = https://github.com/segmentio/aws-okta;
  };
}
