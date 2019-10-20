{ lib
, buildGoModule
, minikube
, hyperkit
}:

buildGoModule rec {
  inherit (minikube) version src nativeBuildInputs goPackagePath postPatch preBuild;

  pname = "docker-machine-hyperkit";
  subPackages = [ "cmd/drivers/hyperkit" ];
  modSha256   = "0v4xq5v5wyji4rj7cwdkii4hjvsryh43d24vplx3a9gi6vy1mh4l";

  buildInputs = minikube.buildInputs ++ lib.singleton hyperkit;

  postInstall = ''
    mv $out/bin/hyperkit $out/bin/docker-machine-driver-hyperkit
  '';

  meta = with lib; {
    homepage = https://github.com/kubernetes/minikube/blob/master/docs/drivers.md;
    description = "HyperKit driver for docker-machine.";
    license = licenses.asl20;
    maintainers = with maintainers; [ atkinschang ];
    platforms = platforms.darwin;
  };
}
