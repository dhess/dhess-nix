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
    enabled = 0;
    hidden = false;
    keepnr = 5;
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

  mkNixpkgsQuixoftic = nixpkgsQuixofticBranch: nixpkgsRev: {
    checkinterval = 60 * 60 * 12;
    inputs = {
      nixpkgs_override = mkFetchGithub "https://github.com/NixOS/nixpkgs-channels.git ${nixpkgsRev}";
      nixpkgsQuixoftic = mkFetchGithub "${nixpkgsQuixofticUri} ${nixpkgsQuixofticBranch}";
    };
  };

  # Temporary jobset while I try to get GHC armv7l upstream.
  mkGhcTest = nixpkgsQuixofticBranch: nixpkgsRev: {
    enabled = 1;
    schedulingshares = 800;
    checkinterval = 60;
    inputs = {
      nixpkgs_override = mkFetchGithub "https://github.com/dhess/nixpkgs.git ${nixpkgsRev}";
      nixpkgsQuixoftic = mkFetchGithub "${nixpkgsQuixofticUri} ${nixpkgsQuixofticBranch}";
    };
  };

  mainJobsets = with pkgs.lib; mapAttrs (name: settings: defaultSettings // settings) (rec {
    nixpkgs-quixoftic = {};
    nixpkgs-quixoftic-nixos-unstable-small = mkNixpkgsQuixoftic "master" "nixos-unstable-small";
    nixpkgs-quixoftic-my-master = mkGhcTest "master" "ghc-armv7l-fix-gcc";
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
