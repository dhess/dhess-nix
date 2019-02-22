# An opinionated "full tunnel" VPN server; i.e., one intended to be
# used as the default route for clients.

{ config, pkgs, lib, ... }:

with lib;

let

  globalCfg = config.services.full-tunnel-vpn;
  enabled = (globalCfg.openvpn != {})         ||
            (globalCfg.wireguard.peers != {}) ||
            globalCfg.strongswan.enable;

  openvpnCfg = import ./openvpn-config.nix {
    inherit pkgs config lib;
    instances = globalCfg.openvpn;
  };
  strongswanCfg = import ./strongswan-config.nix {
    inherit pkgs lib;
    cfg = globalCfg.strongswan;
    keys = config.quixops.keychain.keys;
  };
  wireguardCfg = import ./wireguard-config.nix {
    inherit pkgs lib;
    cfg = globalCfg.wireguard;
    keys = config.quixops.keychain.keys;
  };

in
{

  meta.maintainers = lib.maintainers.dhess-pers;

  options.services.full-tunnel-vpn = {

    routedInterface = mkOption {
      type = pkgs.lib.types.nonEmptyStr;
      example = "eth0";
      description = ''
        Traffic from all VPN clients will be routed via this host
        interface.
      '';
    };
    
    openvpn = mkOption {
      type = types.attrsOf (types.submodule ({ name, ... }: (import ./openvpn-options.nix {
        inherit name config lib pkgs;
      })));
      default = {};
      example = literalExample ''
        vpn1 = {
          ipv4ClientSubnet = "10.0.0.0/24";
          ipv6ClientPrefix = "2001:db8::/64";
          caFile = ./root.crt;
          certFile = ./vpn1.crt;
          certKeyFile = (toString ./vpn1.key);
          crlFile = ./root.crl;
          tlsAuthKeyFile = (toString ./vpn1-tls-auth.key);
        };
      '';
      description = ''
        Declarative OpenVPN "full-tunnel" server instances. Each server
        appears as a service
        <literal>openvpn-<replaceable>name</replaceable></literal> on
        the host system, so that it can be started and stopped via
        <command>systemctl</command>.

        IPv4 traffic that is routed to a full-tunnel OpenVPN server will
        be NATed to the server's public IPv4 address. IPv6 traffic will
        be routed normally and clients will be given a public IPv6
        address from the pool assigned to the OpenVPN server.
      '';
      };

    strongswan = import ./strongswan-options.nix { inherit pkgs lib; };

    wireguard = import ./wireguard-options.nix { inherit pkgs lib; };

  };

  config = mkMerge [
    (mkIf enabled {
      networking.nat.enable = true;
      networking.nat.externalInterface = globalCfg.routedInterface;

      # In-tunnel IPv6 requires some tweaking.
      boot.kernel.sysctl = {
        "net.ipv6.conf.${globalCfg.routedInterface}.accept_ra" = 2;
        "net.ipv6.conf.all.forwarding" = 1;
        "net.ipv6.conf.${globalCfg.routedInterface}.proxy_ndp" = 1;
      };
    })
    openvpnCfg
    strongswanCfg
    wireguardCfg
  ];
}
