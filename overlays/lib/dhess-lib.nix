self: super:

let

  # Provide access to the whole package, if needed.
  path = ../..;

in
{
  lib = (super.lib or {}) // {
    dhess-nix = (super.lib.dhess-nix or {}) // {
      inherit path;
    };
  };
}
