{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "oauth2_proxy";
  version = "4.0.0";

  goPackagePath = "github.com/pusher/${pname}";
  modSha256 = "0zjmah0v8gkz4mn5z46yjz8zng6y397vbz6xm36p6z2p90n6s14n";

  src = fetchFromGitHub {
    repo = pname;
    owner = "pusher";
    sha256 = "1imygy7y5v96szqha2pbi9mbf3j5dbavibp2iwnhp9b36447b0nb";
    rev = "9f920b0fc151ffdc057540c7dfdc87c612a2f8e7";
  };

  meta = with lib; {
    description = "A reverse proxy that provides authentication with Google, Github or other provider";
    homepage = https://github.com/pusher/oauth2_proxy/;
    license = licenses.mit;
    maintainers = [ maintainers.dhess-pers ];
    platforms = platforms.all;
  };
}
