{ config, lib, pkgs, instances, ... }:

with lib;

let

  stateDirFun = name: "/var/lib/openvpn/${name}";
  keys = config.dhess-nix.keychain.keys;

  certKeyName = name: "openvpn-${name}-cert-key";
  tlsAuthKeyName = name: "openvpn-${name}-tls-auth-key";

  dns = cfg: concatMapStrings (x: "push \"dhcp-option DNS ${x}\"\n") cfg.dns;

  genConfig = cfg:
  let
    ipv4ClientBase = pkgs.lib.ipaddr.ipv4AddrFromCIDR cfg.ipv4ClientSubnet;
    netmask = pkgs.lib.ipaddr.netmaskFromIPv4CIDR cfg.ipv4ClientSubnet;
    stateDir = stateDirFun cfg.name;
    certKeyPath = keys."${certKeyName cfg.name}".path;
    tlsAuthKeyPath = keys."${tlsAuthKeyName cfg.name}".path;
  in
  ''
    port ${toString cfg.port}
    proto ${cfg.proto}
    dev tun

    dh ${pkgs.ffdhe3072Pem}
    ca ${cfg.caFile}
    cert ${cfg.certFile}
    key ${certKeyPath}
    crl-verify ${cfg.crlFile}

    topology subnet
    server ${ipv4ClientBase} ${netmask}
    server-ipv6 ${cfg.ipv6ClientPrefix}
    route-ipv6 ${cfg.ipv6ClientPrefix}

    push "redirect-gateway ipv6 bypass-dhcp"
    ${dns cfg}
    push "route-ipv6 2000::/3"

    keepalive 10 120

    tls-auth ${tlsAuthKeyPath} 0

    tls-cipher TLS-ECDHE-ECDSA-WITH-AES-256-GCM-SHA384:TLS-DHE-RSA-WITH-AES-256-GCM-SHA384
    cipher AES-128-GCM
    ecdh-curve secp384r1
    comp-lzo

    user openvpn
    group openvpn

    persist-tun
    persist-key

    duplicate-cn

    replay-persist ${stateDir}/replays.db

    status ${stateDir}/status.log
    verb 4
    mute-replay-warnings
  '';

in
mkIf (instances != {}) {

  dhess-nix.assertions.moduleHashes."services/networking/openvpn.nix" =
    "ddc549a7f879306b31d88f2af1aba79da33d2d8f6f8e4a4c37af0d138e005403";

  dhess-nix.keychain.keys = listToAttrs (filter (x: x.value != null) (
    (mapAttrsToList
      (_: serverCfg: nameValuePair (certKeyName serverCfg.name) ({
        user = "openvpn";
        group = "openvpn";
        destDir = stateDirFun serverCfg.name;
        text = serverCfg.certKeyLiteral;
      })) instances) ++
    (mapAttrsToList
      (_: serverCfg: nameValuePair (tlsAuthKeyName serverCfg.name) ({
        user = "openvpn";
        group = "openvpn";
        destDir = stateDirFun serverCfg.name;
        text = serverCfg.tlsAuthKeyLiteral;
      })) instances)
  ));

  networking.nat.internalIPs =
    (mapAttrsToList
      (_: serverCfg: (
        "${serverCfg.ipv4ClientSubnet}"
       )) instances);

  services.openvpn.servers = listToAttrs (filter (x: x.value != null) (
    (mapAttrsToList
      (_: serverCfg: nameValuePair "${serverCfg.name}" ({
          config = genConfig serverCfg;
        })) instances)
  ));

  systemd.services = listToAttrs (filter (x: x.value != null) (
    (mapAttrsToList
      (_: serverCfg: nameValuePair "openvpn-${serverCfg.name}" (rec {
          wants = [ "keys.target" ];
          after = [ "keys.target" ];
        })) instances)
  ));

  users.users.openvpn = {
    description = "openvpn user";
    name = "openvpn";
    group = "openvpn";
    isSystemUser = true;          
  };
  users.extraGroups.openvpn.name = "openvpn";
}
