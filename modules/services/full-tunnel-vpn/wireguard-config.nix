{ cfg, lib, pkgs, keys, ... }:

with lib;

mkIf (cfg.peers != {}) {

  networking.wireguard-dhess.interfaces.${cfg.interface} = {
    ips = [ cfg.ipv4ClientCidr cfg.ipv6ClientPrefix ];
    listenPort = cfg.listenPort;
    peers =
      (mapAttrs
        (peerName: peerCfg: (
          {
            publicKey = pkgs.lib.fileContents peerCfg.publicKeyFile;
            allowedIPs = peerCfg.allowedIPs;
            endpoint = peerCfg.endpoint;
            presharedKeyLiteral = peerCfg.presharedKeyLiteral;
            persistentKeepalive = 30;
          }
        )) cfg.peers);
  };

  networking.nat.internalIPs = lib.flatten
    (mapAttrsToList
      (_: peerCfg: (
        peerCfg.natInternalIPs
      )) cfg.peers);

}
