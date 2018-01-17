{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libnet-${version}";
  version = "1.1.6";

  src = fetchurl {
    url = "mirror://sourceforge/libnet-dev/${name}.tar.gz";
    sha256 = "0yj6xjk1wwfhqsfjf32hw5jcjvf86f22d84kzirbddn44mcbp4nk";
  };

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
  ];

  meta = with lib; {
    homepage = https://github.com/sam-github/libnet;
    description = "Portable framework for low-level network packet construction";
    license = with licenses; [ bsd2 bsd3 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.dhess ];
  };
}
