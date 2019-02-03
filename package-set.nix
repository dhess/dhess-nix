let
  nixpkgs = (import ./lib.nix).nixpkgs;

in

{ pkgs ? nixpkgs {} }:

with pkgs.lib;
let
  self = foldl'
    (prev: overlay: prev // (overlay (pkgs // self) (pkgs // prev)))
    {} (map import (import ./overlays.nix));
in
self //
{
  # It doesn't make sense to separate the overlay into different
  # attributes, as they're all very much intertwined.
  overlays.all = import ./.;
}
