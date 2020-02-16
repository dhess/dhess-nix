let

  sources = import ../nix/sources.nix;

  fixedDhessLibNix =
  let
    try = builtins.tryEval <dhess_lib_nix>;
  in
    if try.success
      then builtins.trace "Using <dhess_lib_nix>" try.value
      else (import sources.dhess-lib-nix);

  dhess-lib-nix = fixedDhessLibNix {};
  inherit (dhess-lib-nix) lib haskell;
  inherit (lib.fetchers) fixedNixpkgs;
  inherit (lib.dhess-lib-nix) nixpkgs;

  fixedNixOps = lib.fetchers.fixedNixSrc "nixops" sources.nixops;

  fixedAllHies = lib.fetchers.fixedNixSrc "all-hies" sources.all-hies;
  all-hies = (import fixedAllHies) {};

  fixedIHaskell = lib.fetchers.fixedNixSrc "IHaskell" sources.IHaskell;

  fixedLorri = lib.fetchers.fixedNixSrc "lorri" sources.lorri;

  fixedBadhosts = lib.fetchers.fixedNixSrc "badhosts" sources.badhosts;

  fixedHaskellNix = lib.fetchers.fixedNixSrc "haskell-nix" sources.haskell-nix;

  overlays = [
    dhess-lib-nix.overlays.all
  ] ++ (map import [
    ../overlays/apple.nix
    ../overlays/custom-packages.nix
    ../overlays/emacs.nix
    ../overlays/haskell-nix.nix
    ../overlays/haskell-packages.nix
    ../overlays/lib/dhess-lib.nix
    ../overlays/lib/types.nix
    ../overlays/overrides.nix
    ../overlays/patches.nix
    ../overlays/python.nix
    ../overlays/build-support.nix
    ../overlays/build-envs.nix
  ]);

in lib //
{
  inherit fixedNixpkgs;
  inherit nixpkgs;
  inherit haskell;
  inherit overlays;
  inherit fixedAllHies all-hies;
  inherit fixedNixOps;
  inherit fixedIHaskell;
  inherit fixedLorri;
  inherit fixedBadhosts;
  inherit fixedHaskellNix;

  inherit sources;
}
