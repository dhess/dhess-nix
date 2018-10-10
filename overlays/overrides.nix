self: super:

let

  inherit (super) callPackage;

in
{
  # Enable TLS v1.2 and the eapol_test binary in wpa_supplicant.

  wpa_supplicant = super.wpa_supplicant.overrideAttrs (drv: {

    extraConfig = drv.extraConfig + ''
     CONFIG_TLSV12=y
    '';

    patches = drv.patches ++ [
      ./patches/wpa_supplicant/Makefile.eapol_test.patch
    ];

  });
}
