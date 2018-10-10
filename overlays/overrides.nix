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

    # XXX dhess - lib.unique is needed here to work around this issue:
    # https://github.com/NixOS/nixpkgs/issues/34086
    # Otherwise, our patch may be applied twice in some circumstances.

    patches = super.lib.unique (drv.patches ++ [
      ./patches/wpa_supplicant/Makefile.eapol_test.patch
    ]);

  });
}
