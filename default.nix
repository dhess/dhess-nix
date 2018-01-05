# From GitHub: mozilla/nixpkgs-mozilla/default.nix.

self: super:

with super.lib;

(foldl' (flip extends) (_: super) [

  (import ./overlays/custom-packages.nix)
  (import ./overlays/haskell-packages.nix)
  (import ./overlays/kernels.nix)
  (import ./overlays/lib.nix)
  (import ./overlays/patches.nix)
  (import ./overlays/versions.nix)

]) self
