{ stdenv
, fetchFromGitHub
, lib
, makeWrapper
, pkgs
, perl
, perlPackages
}:

let

in
stdenv.mkDerivation rec {

  name = "unbound-block-hosts-${version}";
  version = "20151112";

  src = fetchFromGitHub {
    owner = "jodrell";
    repo = "unbound-block-hosts";
    rev = "87966ee571cdeb78b89d16aac48d8fa2935ad6b2";
    sha256 = "1mc2snciqwcqxpkf9qbcv7xd4287vkd5hdrpmhbi91i44y5q962n";
  };

  buildInputs = [
    makeWrapper
    perl
    perlPackages.GetoptLong
    perlPackages.HTTPDate
    perlPackages.LWP

    # As of July 2018, Dan Pollock's site redirects to HTTPS. The
    # unbound-block-hosts script doesn't support this, but it appears
    # that LWP will automatically redirect if LWP::Protocol::https is
    # installed.
    perlPackages.LWPProtocolHttps
  ];

  installPhase = let path = stdenv.lib.makeBinPath []; in ''
    mkdir -p $out/bin
    cp unbound-block-hosts $out/bin
    wrapProgram $out/bin/unbound-block-hosts --set PERL5LIB $PERL5LIB --prefix PATH : "${path}"
  '';

  meta = with lib; {
    description = "Convert Dan Pollock's ad blocking host file into Unbound local-data";
    maintainers = maintainers.dhess-qx;
    license = licenses.gpl3;
  };
}
