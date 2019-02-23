{ stdenv, lib, fetchgit, perl, cdrkit, syslinux, xz, openssl
, embedScript ? null
}:

let
  date = "20190221";
  rev = "272fe32529103dd39875a9fbed5cfdf1a059e294";
in

stdenv.mkDerivation {
  name = "ipxe-${date}-${builtins.substring 0 7 rev}";

  buildInputs = [ perl cdrkit syslinux xz openssl ];

  src = fetchgit {
    url = git://git.ipxe.org/ipxe.git;
    sha256 = "0gkin279hgli2gspab9pz38s9cfjd2r3g08z7zjfqdqd2vn68npm";
    inherit rev;
  };

  # not possible due to assembler code
  hardeningDisable = [ "pic" "stackprotector" ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

  makeFlags =
    [ "ECHO_E_BIN_ECHO=echo" "ECHO_E_BIN_ECHO_E=echo" # No /bin/echo here.
      "ISOLINUX_BIN_LIST=${syslinux}/share/syslinux/isolinux.bin"
      "LDLINUX_C32=${syslinux}/share/syslinux/ldlinux.c32"
    ] ++ lib.optional (embedScript != null) "EMBED=${embedScript}";


  enabledOptions = [ "DOWNLOAD_PROTO_HTTPS" ];

  configurePhase = ''
    runHook preConfigure
    for opt in $enabledOptions; do echo "#define $opt" >> src/config/general.h; done
    sed -i '/cp \''${ISOLINUX_BIN}/s/$/ --no-preserve=mode/' src/util/geniso
    runHook postConfigure
  '';

  preBuild = "cd src";

  installPhase = ''
    mkdir -p $out
    cp bin/ipxe.dsk bin/ipxe.usb bin/ipxe.iso bin/ipxe.lkrn bin/undionly.kpxe $out

    # Some PXE constellations especially with dnsmasq are looking for the file with .0 ending
    # let's provide it as a symlink to be compatible in this case.
    ln -s undionly.kpxe $out/undionly.kpxe.0
  '';

  enableParallelBuilding = true;

  meta = with lib;
    { description = "Network boot firmware";
      homepage = http://ipxe.org/;
      license = licenses.gpl2;
      maintainers = with maintainers; [ dhess-pers ];
      platforms = platforms.all;
    };
}
