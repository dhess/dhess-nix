self: super:

let

  inherit (super) callPackage;

in rec
{

  # Cherry-picked from later nixpkgs.
  certbot = callPackage ../pkgs/networking/certbot {};

  netsniff-ng = callPackage ../pkgs/networking/netsniff-ng {};

  # Cherry-picked from later nixpkgs.
  simp_le = callPackage ../pkgs/networking/simp_le {};

}
