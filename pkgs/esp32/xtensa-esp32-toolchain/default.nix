{ stdenv
, lib
, fetchurl
, bash
}:

# We download the binary toolchain because building this on macOS
# requires a case-sensitive filesystem.

stdenv.mkDerivation rec {
  version = "1.22.0-73-ge28a011-5.2.0";
  name = "xtensa-esp32-toolchain-${version}";
  arch =
    {
      "x86_64-linux" = "linux64";
      "i686-linux" = "linux32";
      "x86_64-darwin" = "osx";
    }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");

  src = fetchurl {
    url = "https://dl.espressif.com/dl/xtensa-esp32-elf-${arch}-${version}.tar.gz";
    sha256 =
    {
        "x86_64-linux" = "1rg0r8cx1fawvwkkdf0jm3nqk7nj8sf2wqjpfz002fflkznxnqrp";
        "i686-linux" = "0h868sncylbvzzydjr88djrjvwpp5ic17mzp38cbbp13cb8iv2qx";
        "x86_64-darwin" = "1l6h79mly1x6wyj18rg9dkvs0ddb2askh1bc1lfa9xmp5r307day";
    }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");
  };

  dontStrip = true;

  prePatch = ''
    patchShebangs ./
    substituteInPlace ./libexec/gcc/xtensa-esp32-elf/5.2.0/install-tools/mkheaders \
      --replace "/bin/bash" "${bash}/bin/bash"
  '' + stdenv.lib.optionalString stdenv.isLinux ''
    find . -type f -perm -0755 -exec patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" {} \;
  '';

  installPhase = ''
    cp -r . $out
  '';

  meta = with lib; {
    description = "A versatile (cross) toolchain generator, with Xtensa support";
    homepage = https://github.com/espressif/crosstool-NG;
    license = licenses.gpl2;
    maintainers = [ maintainers.dhess-pers ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
  };
}
