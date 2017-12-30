self: super:

let

  inherit (super) callPackage;

in rec
{

  bb-org-overlays = callPackage ../pkgs/hardware/bb-org-overlays {};

  ffmpeg-snapshot = callPackage ../pkgs/multimedia/ffmpeg-snapshot.nix rec {
    inherit (self.pkgs.darwin.apple_sdk.frameworks) Cocoa CoreMedia;
    branch = "20171128.86cead5";
    version = branch;
    rev = "86cead525633cd6114824b33a74d71be677f9546";
    sha256 = "07a0qwr0rd4shbm41n0dg6ip4vb39kxns7qlh1jd81zmvs3xqi0n";
  };

  hyperscan = callPackage ../pkgs/development/libraries/hyperscan {};

  libnet_1_1 = callPackage ../pkgs/development/libraries/libnet/libnet-1.1.nix {};

  libprelude = callPackage ../pkgs/development/libraries/libprelude {};

  unbound-block-hosts = callPackage ../pkgs/dns/unbound-block-hosts.nix {};

  suricata = callPackage ../pkgs/networking/suricata {
    libnet = libnet_1_1;
    redisSupport = true;
    rustSupport = true;
  };

  trimpcap = callPackage ../pkgs/misc/trimpcap {};

  tsoff = callPackage ../pkgs/networking/tsoff {};

}
