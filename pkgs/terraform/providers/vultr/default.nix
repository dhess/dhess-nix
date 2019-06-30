{ stdenv
, lib
, fetchFromGitHub
, buildGoPackage
}:

buildGoPackage rec {
  name = "terraform-provider-vultr-${version}";
  version = "0.1.9";

  goPackagePath = "github.com/squat/terraform-provider-vultr";

  src = fetchFromGitHub {
    owner = "squat";
    repo = "terraform-provider-vultr";
    rev = "48cd5bca883dd8aa0034f9cf054c642b8005ed72";
    sha256 = "05qrvzqpnk9h4y69dykk1y9nbi7rhw9fy2dan2p5gpxmrzx55znj";
  };

  # Terraform allow checking the provider versions, but this breaks
  # if the versions are not provided via file paths.
  postBuild = "mv go/bin/terraform-provider-vultr{,_v${version}}";

  meta = with lib; {
    description = "Terraform provider for Vultr.";
    homepage = "https://github.com/squat/terraform-provider-vultr";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dhess-pers ];
  };
}
