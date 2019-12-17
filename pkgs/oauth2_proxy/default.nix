{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "oauth2_proxy";
  version = "4.1.0";

  goPackagePath = "github.com/pusher/${pname}";
  modSha256 = "0zjmah0v8gkz4mn5z46yjz8zng6y397vbz6xm36p6z2p90n6s14n";

  src = fetchFromGitHub {
    repo = pname;
    owner = "pusher";
    sha256 = "0pl747lf2bxfd75sf1iv9a7lpcv70nvzva4d3ch8k2gi0zlmvvca";
    rev = "8165f6c4835d5c817ca6cd1853698feb136c77b3";
  };

  meta = with lib; {
    description = "A reverse proxy that provides authentication with Google, Github or other provider";
    homepage = https://github.com/pusher/oauth2_proxy/;
    license = licenses.mit;
    maintainers = [ maintainers.dhess-pers ];
    platforms = platforms.all;
  };
}
