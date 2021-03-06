{ system ? "x86_64-linux"
, pkgs
, makeTest
, ...
}:

let

  canary1 = pkgs.copyPathToStore testfiles/canary1;
  canary2 = pkgs.copyPathToStore testfiles/canary2;

in makeTest rec {
  name = "tftpd-hpa";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ dhess-pers ];
  };

  nodes = {

    server1 = { config, ... }: {
      nixpkgs.localSystem.system = system;
      imports =
        pkgs.lib.dhess-nix.modules ++
        pkgs.lib.dhess-nix.testing.testModules;

      networking.firewall.allowedUDPPorts = [ 69 ];
      services.tftpd-hpa.enable = true;

      systemd.services.tftpd-hpa = {
        # Need to make sure we've created the root directory before
        # this starts.
        wants = [ "make-tftp-root.service" ];
        after = [ "make-tftp-root.service" ];
      };

      systemd.services.make-tftp-root = {
        wantedBy = [ "multi-user.target" ];
        script =
        let
          root = config.services.tftpd-hpa.root;
        in
        ''
          mkdir -p ${root}
          cp ${canary1} ${root}/canary1
        '';
      };
    };


    # This server runs tftpd on a virtual IP, to test the
    # listenAddress functionality.

    server2 = { config, ... }: {
      nixpkgs.localSystem.system = system;
      imports =
        pkgs.lib.dhess-nix.modules ++
        pkgs.lib.dhess-nix.testing.testModules;

      networking.firewall.allowedUDPPorts = [ 69 ];
      boot.kernelModules = [ "dummy" ];
      networking.interfaces.dummy0.ipv4.addresses = [
        { address = "192.168.1.100"; prefixLength = 32; }
      ];
      services.tftpd-hpa = {
        enable = true;
        listenAddress = "192.168.1.100";
      };

      systemd.services.tftpd-hpa = {
        # Need to make sure we've created the root directory before
        # this starts.
        wants = [ "make-tftp-root.service" ];
        after = [ "make-tftp-root.service" ];
      };

      systemd.services.make-tftp-root = {
        wantedBy = [ "multi-user.target" ];
        script =
        let
          root = config.services.tftpd-hpa.root;
        in
        ''
          mkdir -p ${root}
          cp ${canary2} ${root}/canary2
        '';
      };
    };

    client = { config, ... }: {
      nixpkgs.localSystem.system = system;

      # Firewalling and tftp are complicated on the client end. We're
      # not trying to test that here.
      networking.firewall.enable = false;
    };

  };

  testScript = { nodes, ... }:
  ''
    startAll;

    $server1->waitForUnit("tftpd-hpa.service");
    $server2->waitForUnit("tftpd-hpa.service");
    $client->waitForUnit("multi-user.target");

    $client->succeed("${pkgs.tftp-hpa}/bin/tftp server1 -c get canary1");
    $client->succeed("diff canary1 ${canary1}");

    $client->succeed("ping -c 1 192.168.1.100 >&2");
    $client->succeed("${pkgs.tftp-hpa}/bin/tftp 192.168.1.100 -c get canary2");
    $client->succeed("diff canary2 ${canary2}");

    $server1->stopJob("tftpd-hpa.service");
  '';
}
