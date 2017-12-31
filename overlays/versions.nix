self: super:

let

  inherit (super) callPackage;

in rec
{

  netsniff-ng = callPackage ../pkgs/networking/netsniff-ng {};

}
