self: super:

let

  inherit (super) callPackage;

in rec
{

  lib = super.lib // rec {

    maintainers = super.lib.maintainers // {
      dhess = "Drew Hess <dhess-src@quixoftic.com>";
    };


    # When called with an argument `extraCerts` whose value is a set
    # mapping strings containing human-friendly certificate authority
    # names to PEM-formatted public CA certificates, this function
    # creates derivation similar to that provided by `super.cacert`, but
    # whose CA cert bundle contains the user-provided extra
    # certificates.
    #
    # For example:
    #
    #   extraCerts = { "Example CA Root Cert" = "-----BEGIN CERTIFICATE-----\nMIIC+..." };
    #   myCacert = mkCacert { inherit extraCerts };
    #
    # will create a new derivation `myCacert` which can be substituted
    # for `super.cacert` wherever that derivation is used, so that, e.g.:
    #
    #   myFetchGit = callPackage <nixpkgs/pkgs/build-support/fetchgit> { cacert = self.myCacert; };
    #
    # creates a `fetchgit` derivation that will accept certificates
    # created by the "Example CA Root Cert" given above.

    mkCacert = (callPackage ../pkgs/security/custom-cacert.nix);
    
  };

}
