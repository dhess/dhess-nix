{ cfg, lib, pkgs, keys, ... }:

with lib;

let

  inherit (builtins) toFile;
  ikev2Port = 500;
  ikev2NatTPort = 4500;
  key = keys.strongswan-cert-key;

  strongSwanDns = concatMapStringsSep "," (x: "${x}") cfg.dns;

  secretsFile = toFile "strongswan.secrets"
    ": RSA ${key.path}";

in
mkIf cfg.enable {

  dhess-nix.assertions.moduleHashes."services/networking/strongswan.nix" =
        "e8f868b5138a4856d9dffcadd210763dbca3150e7b5947870084b072ba351ea2";

  dhess-nix.keychain.keys.strongswan-cert-key = {
    destDir = "/var/lib/strongswan";
    text = cfg.certKeyLiteral;
  };

  services.strongswan = {
    enable = true;
    secrets = [ secretsFile ];
    ca.strongswan = {
      auto = "add";
      cacert = "${cfg.caFile}";
      crlurl = "${cfg.crlFile}";
    };
    setup = { uniqueids = "never"; }; # Allow multiple connections by same cert.
    connections."%default" = {
      keyexchange = "ikev2";
      # Suite-B-GCM-256, Suite-B-GCM-128.
      ike = "aes256gcm16-prfsha384-ecp384,aes128gcm16-prfsha256-ecp256";
      esp = "aes256gcm16-prfsha384-ecp384,aes128gcm16-prfsha256-ecp256";
      fragmentation = "yes";
      dpdaction = "clear";
      dpddelay = "300s";
      rekey = "no";
      left = "%any";
      leftsubnet = "0.0.0.0/0,::/0";
      leftcert = "${cfg.certFile}";
      leftsendcert = "always";
      right = "%any";
      rightsourceip = "${cfg.clientPrefixes.ipv4},${cfg.clientPrefixes.ipv6}";
      rightdns = "${strongSwanDns}";
      auto = "add";
    };
    connections."apple-roadwarrior" = {
      leftid = cfg.remoteId;
      auto = "add";
    };
  };
  
  networking.nat.internalIPs = [ cfg.clientPrefixes.ipv4 ];

  systemd.services.strongswan = {
    wants = [ "keys.target" ];
    after = [ "keys.target" ];
  };

}
