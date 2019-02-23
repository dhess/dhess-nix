{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.dhess-nix.defaults.ssh;
  enabled = cfg.enable;

in
{
  options.dhess-nix.defaults.ssh = {
    enable = mkEnableOption "the dhess-nix SSH configuration defaults.";
  };

  config = mkIf enabled {

    services.openssh.enable = true;
    services.openssh.passwordAuthentication = false;
    services.openssh.permitRootLogin = lib.mkForce "prohibit-password";

    # Prevent users from installing their own authorized_keys.

    services.openssh.authorizedKeysFiles = pkgs.lib.mkForce
      [ "/etc/ssh/authorized_keys.d/%u" ];

    # More reliable GPG forwarding.
    #
    # Use mkOrder 999 to give the user a chance to override it in
    # mkFooter.

    services.openssh.extraConfig = lib.mkOrder 999 ''
      StreamLocalBindUnlink yes
    '';
  };
}
