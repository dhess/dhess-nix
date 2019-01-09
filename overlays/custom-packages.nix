self: super:

let

  inherit (super) callPackage;

  uboots = callPackage ../pkgs/bootloaders/uboot {};

in
{

  debian-ppp = callPackage ../pkgs/networking/debian-ppp {};

  hyperscan = callPackage ../pkgs/development/libraries/hyperscan {};

  libnet_1_1 = callPackage ../pkgs/development/libraries/libnet/libnet-1.1.nix {};

  libprelude = callPackage ../pkgs/development/libraries/libprelude {};

  unbound-block-hosts = callPackage ../pkgs/dns/unbound-block-hosts.nix {};

  suricata = callPackage ../pkgs/networking/suricata {
    libnet = self.libnet_1_1;
    redisSupport = true;
    rustSupport = true;
  };

  trimpcap = callPackage ../pkgs/misc/trimpcap {};

  tsoff = callPackage ../pkgs/networking/tsoff {};

  ubootJetsonTX2 = uboots.ubootJetsonTX2;  

}
