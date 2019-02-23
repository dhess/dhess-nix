{ system ? "x86_64-linux"
, pkgs
, makeTest
, ...
}:

let

  # Don't do this in production -- it will put the secrets into the
  # Nix store! This is just a convenience for the tests.

  ca-cert = pkgs.copyPathToStore ./testfiles/certs/root.crt;
  crl = pkgs.copyPathToStore ./testfiles/crls/acme.com.crl;

  vpn1-cert = pkgs.copyPathToStore ./testfiles/certs/vpn1.acme.com.crt;
  vpn1-certKey = ./testfiles/keys/vpn1.acme.com.key;
  vpn1-certKeyInStore = pkgs.copyPathToStore vpn1-certKey;
  vpn1-tlsAuthKey = ./testfiles/keys/vpn1.acme.com-tls-auth.key;
  vpn1-tlsAuthKeyInStore = pkgs.copyPathToStore vpn1-tlsAuthKey;
  vpn2-cert = pkgs.copyPathToStore ./testfiles/certs/vpn2.acme.com.crt;
  vpn2-certKey = ./testfiles/keys/vpn2.acme.com.key;
  vpn2-certKeyInStore = pkgs.copyPathToStore vpn2-certKey;
  vpn2-tlsAuthKey = ./testfiles/keys/vpn2.acme.com-tls-auth.key;
  vpn2-tlsAuthKeyInStore = pkgs.copyPathToStore vpn2-tlsAuthKey;

  bob-cert = pkgs.copyPathToStore ./testfiles/certs/bob-at-acme.com.crt;
  bob-certKey = pkgs.copyPathToStore ./testfiles/keys/bob-at-acme.com.key;
  alice-cert = pkgs.copyPathToStore ./testfiles/certs/alice-at-acme.com.crt;
  alice-certKey = pkgs.copyPathToStore ./testfiles/keys/alice-at-acme.com.key;

  wg-server-key = ./testfiles/wg-server.key;
  wg-server-keyInStore = pkgs.copyPathToStore wg-server-key;
  wg-client-key = pkgs.copyPathToStore ./testfiles/wg-client.key;
  wg-psk = ./testfiles/wg-psk;
  wg-pskInStore = pkgs.copyPathToStore wg-psk;

  wg-server-pub = ./testfiles/wg-server.pub;
  wg-client-pub = ./testfiles/wg-client.pub;

  openvpnClientConfig = port: proto: cert: key: tlsAuthKey: ''
    remote server ${port} ${proto}
    dev tun
    redirect-gateway def1 ipv6
    persist-tun
    persist-key
    persist-local-ip
    pull
    tls-client
    ca ${ca-cert}
    cert ${cert}
    key ${key}
    remote-cert-tls server
    tls-auth ${tlsAuthKey}
    key-direction 1
    cipher AES-256-CBC
    comp-lzo adaptive
    verb 4
  '';

  client = { config, ... }: {
    nixpkgs.localSystem.system = system;
    networking.interfaces.eth1.ipv6.addresses = [
      { address = "fd00:1234:5678::2000"; prefixLength = 64; }
    ];
    networking.firewall.enable = false;
    environment.etc."openvpn-bob-vpn1.conf" = {
      text = openvpnClientConfig "1194" "udp" bob-cert bob-certKey vpn1-tlsAuthKeyInStore;
    };
    environment.etc."openvpn-alice-vpn1.conf" = {
      text = openvpnClientConfig "1194" "udp" alice-cert alice-certKey vpn1-tlsAuthKeyInStore;
    };
    environment.etc."openvpn-bob-vpn2.conf" = {
      text = openvpnClientConfig "443" "tcp-client" bob-cert bob-certKey vpn2-tlsAuthKeyInStore;
    };
    environment.etc."openvpn-alice-vpn2.conf" = {
      text = openvpnClientConfig "443" "tcp-client" alice-cert alice-certKey vpn2-tlsAuthKeyInStore;
    };
  };

  noOpenvpn = {};

  openvpn = {
    vpn1 = {
      ipv4ClientSubnet = "10.150.0.0/24";
      ipv6ClientPrefix = "fd00:1234:5678:9::/64";
      caFile = ca-cert;
      certFile = vpn1-cert;
      certKeyLiteral = builtins.readFile vpn1-certKey;
      crlFile = crl;
      tlsAuthKeyLiteral = builtins.readFile vpn1-tlsAuthKey;
    };
    vpn2 = {
      port = 443;
      proto = "tcp6";
      ipv4ClientSubnet = "10.150.1.0/24";
      ipv6ClientPrefix = "fd00:1234:5678:a::/64";
      caFile = ca-cert;
      certFile = vpn2-cert;
      certKeyLiteral = builtins.readFile vpn2-certKey;
      crlFile = crl;
      tlsAuthKeyLiteral = builtins.readFile vpn2-tlsAuthKey;
    };
  };

  noStrongswan = { enable = false; };

  strongswan = {
    enable = true;
    remoteId = "vpn1.acme.com";
    clientPrefixes = {
      ipv4 = "10.150.2.1/24";
      ipv6 = "fd00:1234:5678:b::0/64";
    };
    caFile = ca-cert;
    certFile = vpn1-cert;
    certKeyLiteral = builtins.readFile vpn1-certKey;
    crlFile = crl;
  };

  server = openvpn: strongswan: wireguard: { config, ... }: {
    nixpkgs.localSystem.system = system;
    imports =
      pkgs.lib.dhess-nix.modules ++
      pkgs.lib.dhess-nix.testing.testModules;

    # Use the test key deployment system.
    deployment.reallyReallyEnable = true;

    # Turn off the firewall for these tests, as that's not really what
    # we're trying to test here.
    networking.firewall.enable = false;

    services.full-tunnel-vpn = {
      routedInterface = "eth1";
      inherit openvpn;
      inherit strongswan;
      inherit wireguard;
    };
    networking.interfaces.eth1.ipv6.addresses = [
      { address = "fd00:1234:5678::1000"; prefixLength = 64; }
    ];
  };

  noWireguard = {};

  wireguard-server = {
    ipv4ClientCidr = "10.150.3.1/24";
    ipv6ClientPrefix = "fd00:1234:5678:c::0/64";
    privateKeyLiteral = builtins.readFile wg-server-key;
    peers."client" = {
      # Test with a whole LAN behind the remote peer IP.
      allowedIPs = [
        { ip = "10.150.3.2/32"; }
        { ip = "fd00:1234:5678:c::2/64"; }
        { ip =  "10.0.44.0/24"; }
      ];
      natInternalIPs = [ "10.150.3.2/32" "10.0.44.0/24" ];
      publicKeyFile = wg-client-pub;
      presharedKeyLiteral = builtins.readFile wg-psk;
    };
  };

  checkSysctl = ''
    my $accept_ra = $server->succeed("sysctl net.ipv6.conf.eth1.accept_ra");
    $accept_ra =~ /^net\.ipv6\.conf\.eth1\.accept_ra = 2$/ or die "net.ipv6.conf.eth1.accept_ra is not 2";
    my $forwarding = $server->succeed("sysctl net.ipv6.conf.all.forwarding");
    $forwarding =~ /^net\.ipv6\.conf\.all\.forwarding = 1$/ or die "net.ipv6.conf.all.forwarding is not enabled";
    my $proxy_ndp = $server->succeed("sysctl net.ipv6.conf.eth1.proxy_ndp");
    $proxy_ndp =~ /^net\.ipv6\.conf\.eth1\.proxy_ndp = 1$/ or die "net.ipv6.conf.eth1.proxy_ndp is not enabled";
  '';

  ensureIPv6 = ''
    # Make sure we have IPv6 connectivity and there isn't an issue
    # with the network setup in the test.

    sub waitForAddress {
        my ($machine, $iface, $scope) = @_;
        $machine->waitUntilSucceeds("[ `ip -o -6 addr show dev $iface scope $scope | grep -v tentative | wc -l` -eq 1 ]");
        my $ip = (split /[ \/]+/, $machine->succeed("ip -o -6 addr show dev $iface scope $scope"))[3];
        $machine->log("$scope address on $iface is $ip");
        return $ip;
    }

    waitForAddress $client, "eth1", "global";
    waitForAddress $server, "eth1", "global";

    $server->succeed("ping -c 1 fd00:1234:5678::2000 >&2");
    $client->succeed("ping -c 1 fd00:1234:5678::1000 >&2");
  '';

  makeOpenVPNTest = name: client: server: makeTest rec {
    inherit name;

    meta = with pkgs.lib.maintainers; {
      maintainers = [ dhess-pers ];
    };

    nodes = { inherit client server; };

    testScript = { nodes, ... }:
    let
    in ''
      startAll;

      $client->waitForUnit("multi-user.target");
      $server->waitForUnit("openvpn-vpn1.service");
      $server->waitForUnit("openvpn-vpn2.service");

      ${ensureIPv6}

      ${checkSysctl}

      subtest "check-ports", sub {
        my $udp = $server->succeed("ss -u -l -n 'sport = :1194'");
        $udp =~ /\*:1194/ or die "vpn1 does not appear to be listening on UDP port 1194";
        my $tcp = $server->succeed("ss -t -l -n 'sport = :443'");
        $tcp =~ /\*:443/ or die "vpn2 does not appear to be listening on TCP port 443";
      };

      subtest "check-keys", sub {
        $server->succeed("diff ${vpn1-certKeyInStore} /var/lib/openvpn/vpn1/openvpn-vpn1-cert-key");
        $server->succeed("diff ${vpn1-tlsAuthKeyInStore} /var/lib/openvpn/vpn1/openvpn-vpn1-tls-auth-key");
        $server->succeed("diff ${vpn2-certKeyInStore} /var/lib/openvpn/vpn2/openvpn-vpn2-cert-key");
        $server->succeed("diff ${vpn2-tlsAuthKeyInStore} /var/lib/openvpn/vpn2/openvpn-vpn2-tls-auth-key");
      };

      sub testTunIPs {
        my ($tun) = @_;

        # We can't be sure of the mapping of OpenVPN instance to tun
        # device, so the easiest thing to do is just to check all
        # possibilities.
        my $tun_ip = $server->succeed("ip addr show $tun");
        $tun_ip =~ /inet 10\.150\.0\.1\/24/ or $tun_ip =~ /inet 10\.150\.1\.1\/24/ or die "$tun does not have the expected IPv4 address";
        $tun_ip =~ /inet6 fd00:1234:5678:9::1\/64/ or $tun_ip =~ /inet6 fd00:1234:5678:a::1\/64/ or die "$tun does not have the expected IPv6 address";
      };

      subtest "check-addrs", sub {
        testTunIPs "tun0";
        testTunIPs "tun1";
      };

      sub testConnection {
        my ($host, $port, $proto) = @_;
        $client->succeed("${pkgs.netcat}/bin/nc -w 5 $proto $host $port");
      };

      subtest "test-connection", sub {
        testConnection "server", "1194", "-u";
        testConnection "server", "443", "";
        testConnection "fd00:1234:5678::1000", "1194", "-u";
        testConnection "fd00:1234:5678::1000", "443", "";
      };


      ## XXX dhess - these tests time out on TLS negotiation, not sure why.

      # sub testTunnel {
      #   my ($machine, $confFile, $testIP4, $testIP6) = @_;
      #   $machine->execute("${pkgs.openvpn}/bin/openvpn --config $confFile &");
      #   $machine->waitUntilSucceeds("ping -c 1 $testIP4");
      #   $machine->waitUntilSucceeds("ping -c 1 $testIP6");
      # };
      # subtest "test-tunnel", sub {
      #   testTunnel $client, "/etc/openvpn-alice-vpn1.conf", "10.150.0.1", "fd00:1234:5678:9::1";
      #   testTunnel $client, "/etc/openvpn-alice-vpn2.conf", "10.150.1.1", "fd00:1234:5678:a::1";
      # };
    '';
  };

  makeStrongSwanTest = name: client: server: makeTest rec {
    inherit name;

    meta = with pkgs.lib.maintainers; {
      maintainers = [ dhess-pers ];
    };

    nodes = { inherit client server; };

    testScript = { nodes, ... }:
    let
    in ''
      startAll;

      $client->waitForUnit("multi-user.target");
      $server->waitForUnit("strongswan.service");

      ${ensureIPv6}

      ${checkSysctl}

      subtest "check-ports", sub {
        # StrongSwan appears to bind to both *:port and 0.0.0.0:port, so we just look here
        # for any listener. Also, it takes awhile to spin up, so we keep trying.
        $server->waitUntilSucceeds("ss -u -l -n 'sport = :500' | grep 500");
        $server->waitUntilSucceeds("ss -u -l -n 'sport = :4500' | grep 4500");
      };

      subtest "check-keys", sub {
        $server->succeed("diff ${vpn1-certKeyInStore} /var/lib/strongswan/strongswan-cert-key");
      };

      sub testConnection {
        my ($host, $port, $proto) = @_;
        $client->succeed("${pkgs.netcat}/bin/nc -w 5 $proto $host $port");
      };

      subtest "test-connection", sub {
        testConnection "server", "4500", "-u";
        testConnection "server", "500", "-u";
      };
    '';
  };

  makeWireGuardTest = name: client: server: makeTest rec {
    inherit name;

    meta = with pkgs.lib.maintainers; {
      maintainers = [ dhess-pers ];
    };

    nodes = { inherit client server; };

    testScript = { nodes, ... }:
    let
    in ''
      startAll;

      ${ensureIPv6}
      ${checkSysctl}

      $server->waitForUnit("wireguard-wg0.service");
      $client->waitForUnit("multi-user.target");

      subtest "check-ports", sub {
        $server->waitUntilSucceeds("ss -u -l -n 'sport = :51820' | grep 51820");
      };

      subtest "check-keys", sub {
        $server->succeed("diff ${wg-pskInStore} /var/lib/wireguard/wireguard-wg0-client-psk");
        $server->succeed("diff ${wg-server-keyInStore} /var/lib/wireguard/wireguard-wg0-key");
      };

      subtest "check-ips", sub {
        my $wg_ip = $server->succeed("ip addr show wg0");
        $wg_ip =~ /inet 10\.150\.3\.1\/24/ or die "wg0 does not have the expected IPv4 address";
        $server->log("wg0 ip: " . $wg_ip);
        $wg_ip =~ /inet6 fd00:1234:5678:c::\/64/ or die "wg0 does not have the expected IPv6 address";
      };

      sub testConnection {
        my ($host, $port, $proto) = @_;
        $client->succeed("${pkgs.netcat}/bin/nc -w 5 $proto $host $port");
      };

      subtest "test-connection", sub {
        testConnection "server", "51820", "-u";
        testConnection "fd00:1234:5678::1000", "51820", "-u";
      };
    '';
  };

in
{
  ## Generally, we test each type of VPN with a combination of other types enabled/disabled,
  ## to make sure they a) operate alone and b) don't interfere with each other.

  ovpn1 = makeOpenVPNTest "openvpn-full-tunnel" client (server openvpn noStrongswan noWireguard);
  ovpn2 = makeOpenVPNTest "openvpn-full-tunnel+ss+wg" client (server openvpn strongswan wireguard-server);

  strongswan1 = makeStrongSwanTest "strongswan-full-tunnel" client (server noOpenvpn strongswan noWireguard);
  strongswan2 = makeStrongSwanTest "strongswan-full-tunnel+ovpn+wg" client (server openvpn strongswan wireguard-server);

  wireguard1 = makeWireGuardTest "wireguard-full-tunnel" client (server noOpenvpn noStrongswan wireguard-server);
  wireguard2 = makeWireGuardTest "wireguard-full-tunnel+ovpn+wg" client (server openvpn strongswan wireguard-server);
}
