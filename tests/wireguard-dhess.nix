{ system ? "x86_64-linux"
, pkgs
, makeTest
, ...
}:

let

in makeTest rec {
  name = "wireguard-dhess";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ dhess-pers ];
  };

  nodes = {
    peer1 = {
      nixpkgs.localSystem.system = system;
      imports =
        pkgs.lib.dhess-nix.modules ++
        pkgs.lib.dhess-nix.testing.testModules;

      # Use the test key deployment system.
      deployment.reallyReallyEnable = true;

      networking.firewall.allowedUDPPorts = [ 12345 ];
      networking.wireguard-dhess.interfaces.wg0 = {
        ips = [ "10.10.10.1/24" ];
        listenPort = 12345;
      };
    };

    peer2 = {
      nixpkgs.localSystem.system = system;
      imports =
        pkgs.lib.dhess-nix.modules ++
        pkgs.lib.dhess-nix.testing.testModules;

      # Use the test key deployment system.
      deployment.reallyReallyEnable = true;

      networking.firewall.allowedUDPPorts = [ 12345 ];
      networking.wireguard-dhess.interfaces.wg0 = {
        ips = [ "10.10.10.2/24" ];
        listenPort = 12345;
      };
    };
  };

  testScript = ''
    startAll;

    $peer1->waitForUnit("wireguard-wg0.service");
    $peer2->waitForUnit("wireguard-wg0.service");

    my ($retcode, $peer1pubkey) = $peer1->execute("cat /var/lib/wireguard/wireguard-wg0-key.pub");
    $peer1pubkey =~ s/\s+$//;
    if ($retcode != 0) {
      die "Could not read public key from peer1";
    }

    my ($retcode, $peer2pubkey) = $peer2->execute("cat /var/lib/wireguard/wireguard-wg0-key.pub");
    $peer2pubkey =~ s/\s+$//;
    if ($retcode != 0) {
      die "Could not read public key from peer2";
    }

    $peer1->succeed("wg set wg0 peer $peer2pubkey allowed-ips 10.10.10.2/32 endpoint 192.168.1.2:12345 persistent-keepalive 1");
    $peer1->succeed("ip route replace 10.10.10.2/32 dev wg0 table main");

    $peer2->succeed("wg set wg0 peer $peer1pubkey allowed-ips 10.10.10.1/32 endpoint 192.168.1.1:12345 persistent-keepalive 1");
    $peer2->succeed("ip route replace 10.10.10.1/32 dev wg0 table main");

    $peer1->succeed("ping -c1 10.10.10.2");
    $peer2->succeed("ping -c1 10.10.10.1");
  '';
}
