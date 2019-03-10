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
    rev = "v${version}";
    sha256 = "1cfylyfxrns81jx1av60yrdc273ngxhwm2xzfqlvlxxw05p6lcrk";
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
