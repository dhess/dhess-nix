self: super:

let

  inherit (super) callPackage;

in
{

  bb-org-overlays = callPackage ../pkgs/hardware/bb-org-overlays {};

  ffmpeg-snapshot = callPackage ../pkgs/multimedia/ffmpeg-snapshot.nix rec {
    inherit (self.pkgs.darwin.apple_sdk.frameworks) Cocoa CoreMedia;
    branch = "20180107.6c65de3";
    version = branch;
    rev = "6c65de3db06c5379f2ca9173175bfb5f1553518b";
    sha256 = "1n9jcr6rivv0b4szfhr463rljfyzipcc3f7qsdk0apgff9b7xs9j";
  };

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

}
