# nixpkgs-quixoftic

Useful Nixpkgs overlays.

See the Nix files in the `overlays` directory for documentation.

## Overlay

To use this overlay in a Nix derivation, simply import `default.nix`
from this repo into your project's overlays.

## NixOS/nix-darwin

An easy way to use these overlays with NixOS or nix-darwin is to
import the `module/overlays.nix` module into your machine
configuration. This module will add the overlay packages to your
machine's nixpkgs package set.

## Package set

This project can also be used as a
[NUR-style](https://github.com/nix-community/NUR) package set. To use
it this way, see the `package-set.nix` file.
