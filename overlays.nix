let

  localLib = import ./lib.nix;

in
[
  localLib.fetchNixPkgsLibQuixoftic
  localLib.fetchMellon
  localLib.fetchPinPon
  localLib.fetchHpio
  ./overlays/custom-packages.nix
  ./overlays/emacs.nix
  ./overlays/haskell-packages.nix
  ./overlays/lib.nix
  ./overlays/overrides.nix
  ./overlays/patches.nix
]
