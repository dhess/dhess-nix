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

  # ESP32 stuff. Note that these packages are outdated. I haven't had
  # a chance to update them yet, but I want to keep them around in the
  # meantime.
  
  crosstool-ng-xtensa = callPackage ../pkgs/esp32/crosstool-ng-xtensa {};
  xtensa-esp32-toolchain = callPackage ../pkgs/esp32/xtensa-esp32-toolchain {};

in
{
  inherit crosstool-ng-xtensa;
  inherit debian-ppp;
  inherit libprelude;
  inherit unbound-block-hosts;
  inherit suricata;
  inherit trimpcap;
  inherit tsoff;
  inherit xtensa-esp32-toolchain;
}
