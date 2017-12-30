{ stdenv
, lib
, fetchurl
, pkgconfig
, boost
, cmake
, python
, ragel
}:

let

in
stdenv.mkDerivation rec {
  name = "hyperscan-${version}";
  version = "4.6.0";

  src = fetchurl {
    url = "https://github.com/intel/hyperscan/archive/v${version}.tar.gz";
    sha256 = "05d8zpjcm13lldkzcxafkabllzgv10nrhgfazsrag9l2bqpgryqd";
  };

  nativeBuildInputs = [
    boost
    cmake
    pkgconfig
    python
    ragel
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DBUILD_AVX512=ON"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  meta = with lib; {
    homepage = https://01.org/hyperscan;
    description = "A high-performance multiple regex matching library";
    license = with licenses; [ bsd3 bsd2 boost ];
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = [ maintainers.dhess ];
  };
}
