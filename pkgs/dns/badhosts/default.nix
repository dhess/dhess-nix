{ stdenv
, lib
, fetchurl
}:

let

  version = "2.3.10";
  sha256 = "1bpwd3idjnlcj2wbiwxmzpmhhnx42nx569pqwiggfqkzgrbm4rgy";

  generic = { subname, hostsFile, ... }: stdenv.mkDerivation {
    name = "badhosts-${subname}-${version}";
    inherit version;
    src = fetchurl {
      url = "https://github.com/StevenBlack/hosts/archive/${version}.tar.gz";
      inherit sha256;
    };

    # Note that when we generate the Unbound zones file, we skip
    # everything in the source hosts file up to the "# Start
    # StevenBlack" line. This ensures that we won't accidentally
    # create "nxdomain" zones for any addresses that the source hosts
    # file defines (e.g., 0.0.0.0).
    installPhase =
    ''
      mkdir -p $out
      cp ${hostsFile} $out/hosts
      awk '/^# Start StevenBlack/,0' ${hostsFile} | awk '$1 == "0.0.0.0" {print "local-zone: \""$2"\" always_nxdomain"}' > $out/unbound.conf
    '';

    meta = with lib; {
      description = "Steven Black's bad hosts (${subname})";
      maintainers = maintainers.dhess-pers;
      license = licenses.mit;
      platforms = stdenv.lib.platforms.all;
    };
  };

  alternate = subname: generic { inherit subname; hostsFile = "alternates/${subname}/hosts"; };

  badhosts-unified = generic {
    subname = "unified";
    hostsFile = "hosts";
  };

  badhosts-fakenews = alternate "fakenews";
  badhosts-gambling = alternate "gambling";
  badhosts-porn = alternate "porn";
  badhosts-social = alternate "social";
  badhosts-fakenews-gambling = alternate "fakenews-gambling";
  badhosts-fakenews-porn = alternate "fakenews-porn";
  badhosts-fakenews-social = alternate "fakenews-social";
  badhosts-gambling-porn = alternate "gambling-porn";
  badhosts-gambling-social = alternate "gambling-social";
  badhosts-porn-social = alternate "porn-social";
  badhosts-fakenews-gambling-porn = alternate "fakenews-gambling-porn";
  badhosts-fakenews-gambling-social = alternate "fakenews-gambling-social";
  badhosts-fakenews-porn-social = alternate "fakenews-porn-social";
  badhosts-gambling-porn-social = alternate "gambling-porn-social";
  badhosts-fakenews-gambling-porn-social = alternate "fakenews-gambling-porn-social";

  badhosts-all = badhosts-fakenews-gambling-porn-social;

in
{
  inherit badhosts-unified;
  inherit badhosts-fakenews badhosts-gambling badhosts-porn badhosts-social;
  inherit badhosts-fakenews-gambling badhosts-fakenews-porn badhosts-fakenews-social;
  inherit badhosts-gambling-porn badhosts-gambling-social;
  inherit badhosts-porn-social;
  inherit badhosts-fakenews-gambling-porn badhosts-fakenews-gambling-social;
  inherit badhosts-fakenews-porn-social;
  inherit badhosts-gambling-porn-social;
  inherit badhosts-fakenews-gambling-porn-social;
  inherit badhosts-all;
}
