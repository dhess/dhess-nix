{ stdenv
, lib
, fetchurl
}:

let

  generic = { version, sha256, subname, hostsFile, ... }: stdenv.mkDerivation {
    name = "badhosts-${subname}-${version}";
    inherit version;
    src = fetchurl {
      url = "https://github.com/StevenBlack/hosts/archive/v${version}.tar.gz";
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

  badhosts-unified = generic {
    version = "2.3.6";
    sha256 = "0q3x780899334mngfjvg8iwdlp4jl1ynzaf8xm8b1dczr6z5xz2b";
    subname = "unified";
    hostsFile = "hosts";
  };

in
{
  inherit badhosts-unified;
}
