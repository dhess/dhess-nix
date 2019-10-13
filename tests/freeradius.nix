{ system ? "x86_64-linux"
, pkgs
, makeTest
, ...
}:

let

in makeTest rec {
  name = "freeradius";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ dhess-pers ];
  };

  nodes = {
    freeradius = { config, ... }: {
      nixpkgs.localSystem.system = system;
      imports =
        pkgs.lib.dhess-nix.modules ++
        pkgs.lib.dhess-nix.testing.testModules;

      # Use the test key deployment system.
      deployment.reallyReallyEnable = true;

      dhess-nix.freeradius = {
        enable = true;
        interfaces = ["eth0"];
        clients = {
          localhost = {
            ipv4 = "127.0.0.1";
            ipv6 = "::1";
            secretLiteral = "sasquatch";
          };
        };
        tls = {
          caCertificate = ./testfiles/certs/root.crt;
          caCRL = ./testfiles/crls/acme.com.crl;
          serverCertificate = ./testfiles/certs/vpn1.acme.com.crt;
          serverCertificateKeyLiteral = builtins.readFile ./testfiles/keys/vpn1.acme.com.key;
        };
      };
    };
  };

  testScript = { nodes, ... }:
  ''
    startAll;
    $freeradius->waitForUnit("multi-user.target");
    $freeradius->waitForUnit("freeradius.service");
  '';
}
