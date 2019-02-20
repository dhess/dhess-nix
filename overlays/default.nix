self: super:

let

  lib = import ../lib;
  overlays = [
    ./custom-packages.nix
    ./emacs.nix
    ./haskell-packages.nix
    ./lib.nix
    ./overrides.nix
    ./patches.nix
  ];

in
lib.customisation.composeOverlaysFromFiles overlays super
