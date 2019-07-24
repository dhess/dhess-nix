{ config, lib, ... }:

with lib;

let

  cfg = config.dhess-nix.defaults.networking;
  enabled = cfg.enable;

in
{
  options.dhess-nix.defaults.networking = {
    enable = mkEnableOption "the dhess-nix networking configuration defaults.";
  };

  config = mkIf enabled {

    # Upstream enables this by default, but we enable it here as well,
    # just in case something changes upstream or there's a mistake.
    networking.firewall.enable = mkOverride 99 true;

    # Don't use DNSSEC.
    networking.resolvconf.dnsExtensionMechanism = false;
    networking.firewall.allowPing = true;
  };
}
