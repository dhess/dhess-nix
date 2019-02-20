{ ... }:

let

  localLib = import ../lib;

in
{
  nixpkgs.overlays = localLib.overlays;
}
