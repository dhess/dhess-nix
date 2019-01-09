self: super:

let

  inherit (super) callPackage;

  debian-ppp = callPackage ../pkgs/networking/debian-ppp {};

  libprelude = callPackage ../pkgs/development/libraries/libprelude {};

  unbound-block-hosts = callPackage ../pkgs/dns/unbound-block-hosts.nix {};

  suricata = callPackage ../pkgs/networking/suricata {
    redisSupport = true;
    rustSupport = true;
  };

  trimpcap = callPackage ../pkgs/misc/trimpcap {};

  tsoff = callPackage ../pkgs/networking/tsoff {};

in
{
  inherit debian-ppp;
  inherit libprelude;
  inherit unbound-block-hosts;
  inherit suricata;
  inherit trimpcap;
  inherit tsoff;
}
