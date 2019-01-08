self: super:

let

  inherit (super) callPackage;
  lib = import ../lib.nix;
  fixedNixPkgs = lib.fetchNixPkgs;

in
{
  # Use OpenSSL 1.1 in unbound so that it can resolve DNS over TLS names.
  unbound = callPackage (fixedNixPkgs + "/pkgs/tools/networking/unbound") {
    openssl = super.openssl_1_1;
  };


  # Enable TLS v1.2 in wpa_supplicant.

  wpa_supplicant = super.wpa_supplicant.overrideAttrs (drv: {
    extraConfig = drv.extraConfig + ''
     CONFIG_TLSV12=y
    '';
  });
}
