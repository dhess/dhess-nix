{ stdenv
, lib
, fetchgit
, autoconf
, automake
, binutils
, bison
, flex
, gettext
, git
, gperf
, help2man
, libtool
, ncurses
, texinfo
, which
, wget
}:

stdenv.mkDerivation rec {
  name = "crosstool-ng-xtensa-${version}";
  version = "20170110";

  src = fetchgit {
    url = "https://github.com/espressif/crosstool-NG.git";
    rev = "ab8375a958405b85718f09b76fc906a6c3848c69";
    sha256 = "1r2g68jcz2jxssqxzym2i6h6f0v7c10skh1mqcla3bihxr2dp3dk";
    leaveDotGit = true;
  };

  nativeBuildInputs = [ autoconf automake binutils bison flex
    gettext git gperf help2man libtool ncurses texinfo which
    wget ];

  patches =  [ ./gperf-fix.patch ];

  preConfigure = "./bootstrap";

  meta = with lib; {
    description = "A versatile (cross) toolchain generator, with Xtensa support";
    homepage = https://github.com/espressif/crosstool-NG;
    license = licenses.gpl2;
    maintainers = [ maintainers.dhess-qx ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
  };
}
