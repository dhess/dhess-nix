self: super:

let

  inherit (super) callPackage;
  lib = import ../lib.nix;
  fixedNixPkgs = lib.fetchNixPkgs;

  nix_2_1_3 = (callPackage ../pkgs/nix {}).nixStable;

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

  inherit nix_2_1_3;

  # Hydra needs nix-2.1.3 for now.
  hydra = callPackage (fixedNixPkgs + "/pkgs/development/tools/misc/hydra") {
    nix = nix_2_1_3;
  };
}
