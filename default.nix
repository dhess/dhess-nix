let

  lib = import ./lib;
  defaultPkgs = lib.nixpkgs {};

in

{ pkgs ? defaultPkgs }:

let

  overlays = self: super:
    lib.customisation.composeOverlays lib.overlays super;
  self = lib.customisation.composeOverlays (lib.singleton overlays) pkgs;

in
{
  inherit (self) unbound-block-hosts;
  inherit (self) lib;

  overlays.all = overlays;
  modules = self.lib.sources.pathDirectory ./modules;
}
