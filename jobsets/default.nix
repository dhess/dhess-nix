# Based on
# https://github.com/input-output-hk/iohk-ops/blob/df01a228e559e9a504e2d8c0d18766794d34edea/jobsets/default.nix

{ nixpkgs ? <nixpkgs>
, declInput ? {}
}:

let

  nixpkgsQuixofticUri = "https://github.com/quixoftic/nixpkgs-quixoftic.git";

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
    nixexprinput = "nixpkgsQuixoftic";
    description = "Quixoftic Nixpkgs overlay";
    inputs = {
      nixpkgsQuixoftic = mkFetchGithub "${nixpkgsQuixofticUri} master";
    };
  };

  # Build against a nixpkgs-channels repo. This can run fairly often
  # as the channels don't update so much.
  mkNixpkgsChannels = nixpkgsQuixofticBranch: nixpkgsRev: {
    inputs = {
      nixpkgsQuixoftic = mkFetchGithub "${nixpkgsQuixofticUri} ${nixpkgsQuixofticBranch}";
      nixpkgs_override = mkFetchGithub "https://github.com/NixOS/nixpkgs-channels.git ${nixpkgsRev}";
    };
  };

  # Build against the nixpkgs repo. Runs less often due to nixpkgs'
  # velocity.
  mkNixpkgs = nixpkgsQuixofticBranch: nixpkgsRev: {
    checkinterval = 60 * 60 * 12;
    inputs = {
      nixpkgsQuixoftic = mkFetchGithub "${nixpkgsQuixofticUri} ${nixpkgsQuixofticBranch}";
      nixpkgs_override = mkFetchGithub "https://github.com/NixOS/nixpkgs.git ${nixpkgsRev}";
    };
  };

  # Sometimes, during active development, I want to use my fork of
  # nixpkgs. By default, these run as often as the main jobset but
  # with a higher share.
  mkNixpkgsFork = nixpkgsQuixofticBranch: nixpkgsRev: {
    schedulingshares = 400;
    inputs = {
      nixpkgsQuixoftic = mkFetchGithub "${nixpkgsQuixofticUri} ${nixpkgsQuixofticBranch}";
      nixpkgs_override = mkFetchGithub "https://github.com/dhess/nixpkgs.git ${nixpkgsRev}";
    };
  };

  mainJobsets = with pkgs.lib; mapAttrs (name: settings: defaultSettings // settings) (rec {
    master = {};
    nixos-unstable-small = mkNixpkgsChannels "master" "nixos-unstable-small";
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
