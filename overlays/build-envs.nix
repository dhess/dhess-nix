self: super:

let

  mactools-env = super.buildEnv {
    name = "mactools-env";
    paths = with super; [
      ffmpeg
      fm-assistant
      mediainfo
      pinentry_mac
      qrencode
      wireguard-tools
      youtube-dl
    ];
    meta.platforms = super.lib.platforms.darwin;
  };

  nixops-env = super.buildEnv {
    name = "nixops-env";
    paths = with super; [
      dhall-nix
      nixops
      terraform
    ];
    meta.platforms = super.lib.platforms.all;
  };

  nixtools-env = super.buildEnv {
    name = "nixtools-env";
    paths = with super; [
      cabal2nix
      nix-index
      nix-info
      nox
    ];
    meta.platforms = super.lib.platforms.all;
  };

  opsec-env = super.buildEnv {
    name = "opsec-env";
    paths = with super; [
      nmap
    ];
    meta.platforms = super.lib.platforms.all;
  };

  shell-env = super.buildEnv {
    name = "shell-env";
    paths = with super; [
      coreutils
      direnv
      gitAndTools.git-crypt
      gitAndTools.git-extras
      gnumake
      gnupg
      gnused
      dhess-ssh-keygen
      htop
      mosh
      pwgen
      ripgrep
      speedtest-cli
      unbound-block-hosts
      unrar
      wget
      xz
    ];
    meta.platforms = super.lib.platforms.all;
  };

in
{
  inherit mactools-env;
  inherit nixops-env;
  inherit nixtools-env;
  inherit opsec-env;
  inherit shell-env;
}
