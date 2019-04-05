self: super:

let

  inherit (super) callPackage;

  ccextractor = callPackage ../pkgs/multimedia/ccextractor {};

  debian-ppp = callPackage ../pkgs/networking/debian-ppp {};

  libprelude = callPackage ../pkgs/development/libraries/libprelude {};


  # When called with an argument `extraCerts` whose value is a set
  # mapping strings containing human-friendly certificate authority
  # names to PEM-formatted public CA certificates, this function
  # creates derivation similar to that provided by `super.cacert`, but
  # whose CA cert bundle contains the user-provided extra
  # certificates.
  #
  # For example:
  #
  #   extraCerts = { "Example CA Root Cert" = "-----BEGIN CERTIFICATE-----\nMIIC+..." };
  #   myCacert = mkCacert { inherit extraCerts };
  #
  # will create a new derivation `myCacert` which can be substituted
  # for `super.cacert` wherever that derivation is used, so that, e.g.:
  #
  #   myFetchGit = callPackage <nixpkgs/pkgs/build-support/fetchgit> { cacert = self.myCacert; };
  #
  # creates a `fetchgit` derivation that will accept certificates
  # created by the "Example CA Root Cert" given above.
  #
  # The cacert package in Nixpkgs allows the user to provide extra
  # certificates; however, these extra certificates are not visible to
  # some packages which hard-wire their cacert package, such as many
  # of nixpkgs's fetch functions. It's for that reason that this
  # function exists.
  mkCacert = (callPackage ../pkgs/security/custom-cacert.nix);

  ppp-devel = callPackage ../pkgs/networking/ppp-devel {};

  badhosts = callPackage ../pkgs/dns/badhosts {};

  suricata = callPackage ../pkgs/networking/suricata {
    # not strictly necessary for the overlay, but needed for building
    # this for the NUR package set.
    inherit libprelude;

    redisSupport = true;
    rustSupport = true;
  };

  trimpcap = callPackage ../pkgs/misc/trimpcap {};

  tsoff = callPackage ../pkgs/networking/tsoff {};

  # ESP32 stuff. Note that these packages are outdated. I haven't had
  # a chance to update them yet, but I want to keep them around in the
  # meantime.
  
  crosstool-ng-xtensa = callPackage ../pkgs/esp32/crosstool-ng-xtensa {};
  xtensa-esp32-toolchain = callPackage ../pkgs/esp32/xtensa-esp32-toolchain {};

  terraform-provider-vultr = callPackage ../pkgs/terraform/providers/vultr {};

  dhess-nix-source = callPackage ../pkgs/dhess-nix-source { inherit (super) packageSource; };

in
{
  inherit (badhosts) badhosts-unified;
  inherit (badhosts) badhosts-fakenews badhosts-gambling badhosts-porn badhosts-social;
  inherit (badhosts) badhosts-fakenews-gambling badhosts-fakenews-porn badhosts-fakenews-social;
  inherit (badhosts) badhosts-gambling-porn badhosts-gambling-social;
  inherit (badhosts) badhosts-porn-social;
  inherit (badhosts) badhosts-fakenews-gambling-porn badhosts-fakenews-gambling-social;
  inherit (badhosts) badhosts-fakenews-porn-social;
  inherit (badhosts) badhosts-gambling-porn-social;
  inherit (badhosts) badhosts-fakenews-gambling-porn-social;
  inherit (badhosts) badhosts-all;

  inherit ccextractor;
  inherit crosstool-ng-xtensa;
  inherit dhess-nix-source;
  inherit debian-ppp;
  inherit libprelude;
  inherit mkCacert;
  inherit ppp-devel;
  inherit suricata;
  inherit terraform-provider-vultr;
  inherit trimpcap;
  inherit tsoff;
  inherit xtensa-esp32-toolchain;
}
