self: super:

let

  inherit (super) callPackage;

in
{

  hydra = callPackage ../pkgs/ci/hydra {};

}
