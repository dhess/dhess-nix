{ config
, lib
, ...
}:

with lib;

let

  cfg = config.dhess-nix.defaults.acme;
  enabled = cfg.enable;

in
{
  options.dhess-nix.defaults.acme = {
    enable = mkEnableOption "the dhess-nix ACME module configuration defaults.";
  };

  config = mkIf enabled {
    security.acme.acceptTerms = true;
  };
}
