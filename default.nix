let

  lib = import ./lib;
  defaultPkgs = lib.nixpkgs {};
  localOverlays = lib.overlays;

in

{ pkgs ? defaultPkgs }:

let

  self = lib.customisation.composeOverlays localOverlays pkgs;

in
{
  inherit (self) unbound-block-hosts;
  inherit (self) lib;

  overlays.all = localOverlays;
  modules = self.lib.sources.pathDirectory ./modules;
}
