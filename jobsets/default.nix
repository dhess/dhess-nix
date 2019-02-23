# Based on
# https://github.com/input-output-hk/iohk-ops/blob/df01a228e559e9a504e2d8c0d18766794d34edea/jobsets/default.nix

{ nixpkgs ? <nixpkgs>
, declInput ? {}
}:

let

  dhessNixUri = "https://github.com/dhess/dhess-nix.git";

  mkFetchGithub = value: {
    inherit value;
    type = "git";
    emailresponsible = false;
  };

  nixpkgs-src = builtins.fromJSON (builtins.readFile ../nixpkgs-src.json);

  pkgs = import nixpkgs {};

  defaultSettings = {
    enabled = 1;
    hidden = false;
    keepnr = 20;
    schedulingshares = 100;
    checkinterval = 60;
    enableemail = false;
    emailoverride = "";
    nixexprpath = "jobsets/release.nix";
    nixexprinput = "dhessNix";
    description = "A useful Nixpkgs overlay";
    inputs = {
      dhessNix = mkFetchGithub "${dhessNixUri} master";
    };
  };

  # Build against a nixpkgs-channels repo. This can run fairly often
  # as the channels don't update so much.
  mkNixpkgsChannels = dhessNixBranch: nixpkgsRev: {
    inputs = {
      dhessNix = mkFetchGithub "${dhessNixUri} ${dhessNixBranch}";
      nixpkgs_override = mkFetchGithub "https://github.com/NixOS/nixpkgs-channels.git ${nixpkgsRev}";
    };
  };

  # Build against the nixpkgs repo. Runs less often due to nixpkgs'
  # velocity.
  mkNixpkgs = dhessNixBranch: nixpkgsRev: {
    checkinterval = 60 * 60 * 12;
    inputs = {
      dhessNix = mkFetchGithub "${dhessNixUri} ${dhessNixBranch}";
      nixpkgs_override = mkFetchGithub "https://github.com/NixOS/nixpkgs.git ${nixpkgsRev}";
    };
  };

  # Sometimes, during active development, I want to use a "staging"
  # branch to test ugprades. By default, these run as often as the
  # main jobset but with a higher share.
  mkStaging = dhessNixBranch: nixpkgsRev: {
    schedulingshares = 400;
    inputs = {
      dhessNix = mkFetchGithub "${dhessNixUri} ${dhessNixBranch}";
      nixpkgs_override = mkFetchGithub "https://github.com/NixOS/nixpkgs.git ${nixpkgsRev}";
    };
  };

  # Run the NixOS modules tests, rather than the package set tests.
  nixosTests = settings: settings // {
    nixexprpath = "jobsets/release-nixos.nix";
    description = "dhess-nix NixOS modules";
  };

  mainJobsets = with pkgs.lib; mapAttrs (name: settings: defaultSettings // settings) (rec {
    master = {};
    nixos-unstable = mkNixpkgsChannels "master" "nixos-unstable";
    nixpkgs-unstable = mkNixpkgsChannels "master" "nixpkgs-unstable";
    nixpkgs = mkNixpkgs "master" "master";
    quixops-modules = nixosTests (mkStaging "quixops-modules" "969cff2691a02b3d7e5468beda26c482d8986644");
  });

  jobsetsAttrs = mainJobsets;

  jobsetJson = pkgs.writeText "spec.json" (builtins.toJSON jobsetsAttrs);

in {
  jobsets = with pkgs.lib; pkgs.runCommand "spec.json" {} ''
    cat <<EOF
    ${builtins.toJSON declInput}
    EOF
    cp ${jobsetJson} $out
  '';
}
