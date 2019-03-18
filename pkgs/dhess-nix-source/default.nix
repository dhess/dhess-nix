{ packageSource
, version ? "1.0"
, selfSrc ? ../..
}:

packageSource "dhess-nix-source" version selfSrc
