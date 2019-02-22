{ system ? "x86_64-linux"
, pkgs
, makeTest
, ...
}:


let

  hostsfile = pkgs.writeText "hostsfile" ''
    #<localhost>
    127.0.0.1	localhost
    127.0.0.1	localhost.localdomain
    255.255.255.255	broadcasthost
    ::1		localhost
    127.0.0.1	local
    #fe80::1%lo0	localhost
    #</localhost>
    #<doubleclick-sites>
    127.0.0.1 doubleclick.com
    127.0.0.1 doubleclick.de
    127.0.0.1 doubleclick.net        
  '';

  makeUbhTest = name: clientAttrs:
    makeTest {

      name = "unbound-block-hosts-${name}";

      meta = with pkgs.lib.maintainers; {
        maintainers = [ dhess-pers ];
      };

      nodes = {

        server = { config, ... }: {
          nixpkgs.localSystem.system = system;
          networking.firewall.allowedTCPPorts = [ 80 443 ];
          services.nginx = {
            enable = true;
            virtualHosts."server" = {
              locations."/".root = pkgs.runCommand "docroot" {} ''
                mkdir -p "$out/hosts"
                cp "${hostsfile}" "$out/hosts/hosts"
              '';
            };
          };          
        };

        client = { config, ... }: {
          nixpkgs.localSystem.system = system;
          imports = pkgs.lib.dhess-nix.modules;
        } // clientAttrs;

      };

      testScript = { nodes, ... }:
      ''
        startAll;
        $client->waitForUnit("multi-user.target");
        $server->waitForUnit("nginx.service");

        subtest "download-blocklist", sub {
          $client->succeed("${pkgs.unbound-block-hosts}/bin/unbound-block-hosts --url=http://server/hosts/hosts --file=/tmp/blockhosts.conf");
          $client->succeed("grep 'local-data: \"doubleclick.com A 127.0.0.1\"\' /tmp/blockhosts.conf");
        };
      '';

    };

in
{

  ubh = makeUbhTest "default" { };

}
