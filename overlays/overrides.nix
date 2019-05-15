self: super:

let

  inherit (super) callPackage;

  # Revert to grub 2.02. Upstream broke it for EC2 instances in
  # df4d0fab2f62fc1ce1d904dbbfd29e5c66da67bf.

  grub2_full = callPackage ../pkgs/grub/2.0x.nix { };

  grub2 = grub2_full;

  grub2_efi = grub2.override {
    efiSupport = true;
  };

  grub2_light = grub2.override {
    zfsSupport = false;
  };

  grub2_xen = grub2_full.override {
    xenSupport = true;
  };

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

  inherit grub2 grub2_full grub2_efi grub2_light grub2_xen;
}
