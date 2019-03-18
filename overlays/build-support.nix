self: super:

let

  # Override dhallToNix with our fixed dhall-nix. Otherwise,
  # derivations that use dhallToNix won't benefit from our fixed
  # dhall-nix package. (I believe this is necessary due to the fact
  # that dhallToNix uses import-from-derivation.)
  dhallToNix = super.dhallToNix.override (origArgs: {
    inherit (super) dhall-nix;
  });

  dhallToNixFromFile = super.callPackage ../pkgs/build-support/dhall-to-nix-from-file {
    inherit dhallToNix;
  };

  ## We define a few dummy packages for testing dhallToNix* support.
  hello-dhall-file = dhallToNixFromFile ../pkgs/build-support/tests/hello.dhall;

in
{
  inherit dhallToNix dhallToNixFromFile;

  inherit hello-dhall-file;
}
