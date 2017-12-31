# The packageSet rigamarole is necessary for now because, until very
# recently, release-lib.nix from Nixpkgs did not support armv7l-linux,
# which we need. Until we're running that version of Nixpkgs (or
# later), we have grabbed release-lib.nix from that revision and use
# it locally; but since it imports both the packageSet and lib, we
# have modified it slightly to be pure.
#
# See
# https://github.com/NixOS/nixpkgs/commit/b1a2e1caef0879ff427ce34abbbbdea9dfb75d00

let

  # XXX dhess - When we've updated to the latest Nixpkgs, uncomment
  # this line and remove the other bindings below.

  #fixedNixPkgs = (import ../lib.nix).fetchNixPkgs;

  lib = import ../lib.nix;
  fixedNixPkgs = lib.fetchNixPkgs;
  packageSet = (import fixedNixPkgs);

in

{ supportedSystems ? [ "x86_64-linux" "armv7l-linux" "aarch64-linux" ]
, scrubJobs ? true
, nixpkgsArgs ? {
    config = { allowUnfree = false; inHydra = true; };
    overlays = [ (import ../.) ];
  }
}:

# XXX dhess - When we've updated to the latest Nixpkgs, uncomment this
# import expression and remove the import expression below it (along
# with our local, modified release-lib.nix).

# with import (fixedNixPkgs + "/pkgs/top-level/release-lib.nix") {
#   inherit supportedSystems scrubJobs nixpkgsArgs;
# };

with import ./release-lib.nix {
  inherit lib supportedSystems scrubJobs nixpkgsArgs packageSet;
};

let

  jobs = {

    x86_64-linux = pkgs.releaseTools.aggregate {
      name = "nixpkgs-quixoftic-x86_64-linux";
      meta.description = "nixpkgs-quixoftic overlay packages (x86_64-linux)";
      meta.maintainer = lib.maintainers.dhess;
      constituents = with jobs; [
        certbot.x86_64-linux
        ffmpeg-snapshot.x86_64-linux
        gitaly.x86_64-linux
        hyperscan.x86_64-linux
        libnet_1_1.x86_64-linux
        libprelude.x86_64-linux
        netsniff-ng.x86_64-linux
        simp_le.x86_64-linux
        suricata.x86_64-linux
        trimpcap.x86_64-linux
        tsoff.x86_64-linux
        unbound-block-hosts.x86_64-linux
      ];
    };

    armv7l-linux = pkgs.releaseTools.aggregate {
      name = "nixpkgs-quixoftic-armv7l-linux";
      meta.description = "nixpkgs-quixoftic overlay packages (armv7l-linux)";
      meta.maintainer = lib.maintainers.dhess;
      constituents = with jobs; [
        bb-org-overlays.armv7l-linux
        certbot.armv7l-linux
        jemalloc.armv7l-linux
        linux_beagleboard.armv7l-linux
        simp_le.armv7l-linux
      ];
    };

  } // (mapTestOn (packagePlatforms pkgs));

in
{
  inherit (jobs) x86_64-linux;
  inherit (jobs) armv7l-linux;
}
