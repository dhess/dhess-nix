{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.dhess-nix.defaults.environment;
  enabled = cfg.enable;

in
{
  options.dhess-nix.defaults.environment = {
    enable = mkEnableOption "Enable the dhess-nix shell environment configuration defaults.";
  };

  config = mkIf enabled {

    environment.systemPackages = with pkgs; [
      emacs25-nox
      git
      wget
    ];

    environment.shellAliases = {
      l = "ls -F";
      ll = "ls -alF";
      ls = "ls -F";
      ltr = "ls -alFtr";
      m = "more";
      more = "less";
      mroe = "less";
      pfind = "ps auxww | grep";
    };

    # Disable HISTFILE globally.
    environment.interactiveShellInit =
      ''
        unset HISTFILE
      '';

    environment.noXlibs = true;

    programs.bash.enableCompletion = true;

  };

}
