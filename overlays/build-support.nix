self: super:

let

  # Override dhallToNix with our fixed dhall-nix. Otherwise,
  # derivations that use dhallToNix won't benefit from our fixed
  # dhall-nix package. (I believe this is necessary due to the fact
  # that dhallToNix uses import-from-derivation.)
  dhallToNix = super.dhallToNix.override (origArgs: {
    inherit (super) dhall-nix;
  });


  # Like dhallToNix, but from a file, rather than a literal string
  # argument. Note that this works only with a single, self-contained
  # Dhall file. If that Dhall file imports Dhall code from another
  # file, use dhallToNixFromSrc.
  dhallToNixFromFile = super.callPackage ../pkgs/build-support/dhall-to-nix-from-file {
    inherit dhallToNix;
  };


  # Create a Nix expression from an arbitrary Dhall program, given a
  # properly-defined Nixpkgs source expression and the file containing
  # the top-level Dhall expression. This works even if the top-level
  # Dhall expression imports other Dhall expressions.
  dhallToNixFromSrc = super.callPackage ../pkgs/build-support/dhall-to-nix-from-src {
    inherit (super) dhall-nix;
  };


  ## We define a few dummy packages for testing dhallToNix* support.

  hello-dhall-file = dhallToNixFromFile ../pkgs/build-support/tests/hello.dhall;
  hello-dhall-src = dhallToNixFromSrc ../pkgs/build-support/tests/hello "hello.dhall";

in
{
  inherit dhallToNix dhallToNixFromFile dhallToNixFromSrc;

  inherit hello-dhall-file hello-dhall-src;
}
