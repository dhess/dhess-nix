let

  # From https://github.com/input-output-hk/iohk-ops/blob/e6f1ae95cdbfdd5c213aa0b9a1ef67150febc503/lib.nix
  
  fetchNixPkgs =
  let
    try = builtins.tryEval <nixpkgs_override>;
  in
    if try.success
      then builtins.trace "Using <nixpkgs_override>" try.value
      else (import ./fetch-github.nix) { jsonSpec = builtins.readFile ./nixpkgs-src.json; };

  fetchHpio =
  let
    try = builtins.tryEval <hpio_override>;
  in
    if try.success
      then builtins.trace "Using <hpio_override>" try.value
      else (import ./fetch-github.nix) { jsonSpec = builtins.readFile ./hpio-src.json; };

  fetchMellon =
  let
    try = builtins.tryEval <mellon_override>;
  in
    if try.success
      then builtins.trace "Using <mellon_override>" try.value
      else (import ./fetch-github.nix) { jsonSpec = builtins.readFile ./mellon-src.json; };

  fetchPinPon =
  let
    try = builtins.tryEval <pinpon_override>;
  in
    if try.success
      then builtins.trace "Using <pinpon_override>" try.value
      else (import ./fetch-github.nix) { jsonSpec = builtins.readFile ./pinpon-src.json; };

  nixpkgs = import fetchNixPkgs;

  pkgs = nixpkgs {};

  lib = pkgs.lib;

in lib // (rec {

  inherit fetchNixPkgs;
  inherit fetchHpio;
  inherit fetchMellon;
  inherit fetchPinPon;

})
