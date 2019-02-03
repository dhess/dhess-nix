{ ... }:

let

in
{
  nixpkgs.overlays = import ../.;
}
