self: super:

let

  myPass = super.pass.withExtensions (ext: [
    ext.pass-audit
    ext.pass-genphrase
    ext.pass-update
  ]);

  mactools-env = super.buildEnv {
    name = "mactools-env";
    paths = with super; [
      ccextractor
      ffmpeg
      fm-assistant
      mediainfo
      myPass
      pinentry_mac
      qrencode
      wireguard-tools
      youtube-dl
      yubico-piv-tool
      yubikey-manager
      yubikey-personalization
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
      nix-delegate
      nix-deploy
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
      gitAndTools.git-secrets
      gnumake
      gnupg
      gnused
      dhess-ssh-keygen
      htop
      mosh
      pwgen
      ripgrep
      speedtest-cli
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
