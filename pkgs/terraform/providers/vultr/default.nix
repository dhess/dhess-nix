{ stdenv
, lib
, fetchFromGitHub
, buildGoPackage
}:

buildGoPackage rec {
  name = "terraform-provider-vultr-${version}";
  version = "0.1.10";

  goPackagePath = "github.com/squat/terraform-provider-vultr";

  src = fetchFromGitHub {
    owner = "squat";
    repo = "terraform-provider-vultr";
    rev = "1616f3c28af1c3810c692e9e48cfee3a7c867060";
    sha256 = "1rysny8ghnbg9q6ipgprqk7xxhr04667ia6p15cv25ivvxpk3as0";
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
