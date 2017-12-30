let

  fixedNixPkgs = (import ../lib.nix).fetchNixPkgs;

in

{ supportedSystems ? [ "x86_64-linux" ]
, scrubJobs ? true
, nixpkgsArgs ? {
    config = { allowUnfree = true; allowBroken = true; inHydra = true; };
    overlays = [ (import ../.) ];
  }
}:

with import (fixedNixPkgs + "/pkgs/top-level/release-lib.nix") {
  inherit supportedSystems scrubJobs nixpkgsArgs;
};

let

  jobs = mapTestOn ((packagePlatforms pkgs) // {

    jemalloc = [ "armv7l-linux" ];
    linux_beagleboard = [ "armv7l-linux" ];
    linuxPackages_beagleboard = [ "armv7l-linux" ];

  });

in rec
{
  ## Custom packages.
  #

  inherit (jobs) bb-org-overlays;
  inherit (jobs) ffmpeg-snapshot;
  inherit (jobs) hyperscan;
  inherit (jobs) libnet_1_1;
  inherit (jobs) libprelude;
  inherit (jobs) unbound-block-hosts;
  inherit (jobs) suricata;
  inherit (jobs) trimpcap;
  inherit (jobs) tsoff;


  ## Disabled tests.
  #

  inherit (jobs) jemalloc;


  ## Kernels
  #

  inherit (jobs) linux_beagleboard;
  inherit (jobs) linuxPackages_beagleboard;


  ## Patched derivations.
  #

  inherit (jobs) gitaly;


  ## Overridden package versions.
  #

  inherit (jobs) certbot;
  inherit (jobs) netsniff-ng;
  inherit (jobs) simp_le;

}
