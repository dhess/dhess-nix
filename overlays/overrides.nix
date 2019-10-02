self: super:

let

  inherit (super) callPackage;

  # Upstream cfssl is out of date.
  cfssl = callPackage ../pkgs/cfssl {};

  # More recent version than upstream.
  aws-vault = callPackage ../pkgs/aws-vault {};

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
  #
  # Don't override super; it disables a bunch of things on macOS.
  ffmpeg-full = callPackage (super.path + "/pkgs/development/libraries/ffmpeg-full") {
    nonfreeLicensing = true;
    fdkaacExtlib = true;
    fdk_aac = super.fdk_aac;
    nvenc = false;
    inherit (super.darwin.apple_sdk.frameworks)
      Cocoa CoreServices CoreAudio AVFoundation MediaToolbox
      VideoDecodeAcceleration;

    frei0r = if super.stdenv.isDarwin then null else super.frei0r;
  };

  inherit aws-vault;
  inherit cfssl;
}
