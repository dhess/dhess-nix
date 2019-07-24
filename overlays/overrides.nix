self: super:

let

  inherit (super) callPackage;

  # lz4 in upstream is broken on macOS until a patch from staging is merged.
  lz4 = callPackage ../pkgs/misc/lz4 {};

in
{
  # A more recent ipxe than nixpkgs has.
  ipxe = callPackage ../pkgs/misc/ipxe {};

  # Use OpenSSL 1.1 in unbound so that it can resolve DNS over TLS names.
  unbound = callPackage (super.path + "/pkgs/tools/networking/unbound") {
    openssl = super.openssl_1_1;
  };


  # Enable TLS v1.2 in wpa_supplicant.
  wpa_supplicant = super.wpa_supplicant.overrideAttrs (drv: {
    extraConfig = drv.extraConfig + ''
     CONFIG_TLSV12=y
    '';
  });

  # Use fdk_aac in ffmpeg-full.
  ffmpeg-full = super.ffmpeg-full.override {
    fdk_aac = super.fdk_aac;
  };

  inherit lz4;
}
