let

  lib = import ../lib;
  inherit (lib) fixedNixpkgs;
  localPkgs = (import ../.) {};

in

{ supportedSystems ? [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" ]
, scrubJobs ? true
, nixpkgsArgs ? {
    config = { allowUnfree = true; allowBroken = true; inHydra = true; };
    overlays = lib.singleton localPkgs.overlays.all;
  }
}:

with import (fixedNixpkgs + "/pkgs/top-level/release-lib.nix") {
  inherit supportedSystems scrubJobs nixpkgsArgs;
};

let

  x86_64 = [ "x86_64-linux" "x86_64-darwin" ];
  x86_64_linux = [ "x86_64-linux" ];
  linux = [ "x86_64-linux" "aarch64-linux" ];

  jobs = (mapTestOn (rec {
    aws-okta = all;
    aws-sam-cli = all;
    aws-vault = all;

    badhosts-unified = all;
    badhosts-fakenews = all;
    badhosts-gambling = all;
    badhosts-porn = all;
    badhosts-social = all;
    badhosts-fakenews-gambling = all;
    badhosts-fakenews-porn = all;
    badhosts-fakenews-social = all;
    badhosts-gambling-porn = all;
    badhosts-gambling-social = all;
    badhosts-porn-social = all;
    badhosts-fakenews-gambling-porn = all;
    badhosts-fakenews-gambling-social = all;
    badhosts-fakenews-porn-social = all;
    badhosts-gambling-porn-social = all;
    badhosts-fakenews-gambling-porn-social = all;
    badhosts-all = all;

    ccextractor = x86_64;
    cfssl = all;
    chamber = all;
    crosstool-ng-xtensa = x86_64;
    debian-ppp = linux;
    delete-tweets = all;
    dhess-ssh-keygen = all;
    dovecot_pigeonhole = all;
    ffmpeg-full = x86_64;
    fm-assistant = darwin;
    fsatrace = all;
    gawk_4_2_1 = all;
    ghcide = all;
    hydra = x86_64_linux;
    ipxe = x86_64_linux;
    libprelude = x86_64_linux;
    libvmaf = x86_64;
    lorri = all;
    nano = all;
    netsniff-ng = x86_64_linux;
    nixops = x86_64;
    nmrpflash = all;
    ntp = linux;
    oauth2_proxy = all;
    ppp-devel = linux;
    radare2 = all;
    terraform-provider-okta = all;
    terraform-provider-vultr = all;
    trimpcap = linux;
    tsoff = linux;
    unbound = linux;
    wpa_supplicant = linux;
    xtensa-esp32-toolchain = x86_64;

    emacs = darwin;
    emacs-env = darwin;
    emacs-nox = linux;
    emacs-nox-env = linux;
    emacs-macport-env = darwin;

    hyperkit = darwin;
    minikube = all;

    haskell-env = all;
    extensive-haskell-env = x86_64;

    haskell882-env = all;

    ihaskell = darwin;
    ihaskell-env = darwin;
    ihaskell-envfun = darwin;
    extensive-ihaskell-env = darwin;
    extensive-ihaskell-envfun = darwin;

    python-env = all;

    anki = darwin;
    anki-env = darwin;
    mactools-env = darwin;
    maths-env = x86_64;
    minikube-env = all;
    nixops-env = x86_64;
    nixtools-env = all;
    opsec-env = all;
    shell-env = darwin;

    # Won't evaluate in Hydra because it's not a proper derivation.
    #hello-dhall-file = all;
    #hello-dhall-src = all;

    dhess-nix-source = all;
  })) // (rec {
    x86_64-linux = pkgs.releaseTools.aggregate {
      name = "dhess-nix-x86_64-linux";
      meta.description = "dhess-nix overlay packages (x86_64-linux)";
      meta.maintainer = lib.maintainers.dhess-pers;
      constituents = with jobs; [
        aws-okta.x86_64-linux
        aws-sam-cli.x86_64-linux

        badhosts-unified.x86_64-linux
        badhosts-fakenews.x86_64-linux
        badhosts-gambling.x86_64-linux
        badhosts-porn.x86_64-linux
        badhosts-social.x86_64-linux
        badhosts-fakenews-gambling.x86_64-linux
        badhosts-fakenews-porn.x86_64-linux
        badhosts-fakenews-social.x86_64-linux
        badhosts-gambling-porn.x86_64-linux
        badhosts-gambling-social.x86_64-linux
        badhosts-porn-social.x86_64-linux
        badhosts-fakenews-gambling-porn.x86_64-linux
        badhosts-fakenews-gambling-social.x86_64-linux
        badhosts-fakenews-porn-social.x86_64-linux
        badhosts-gambling-porn-social.x86_64-linux
        badhosts-fakenews-gambling-porn-social.x86_64-linux
        badhosts-all.x86_64-linux

        ccextractor.x86_64-linux
        chamber.x86_64-linux
        cfssl.x86_64-linux
        crosstool-ng-xtensa.x86_64-linux
        debian-ppp.x86_64-linux
        dhess-ssh-keygen.x86_64-linux
        dovecot_pigeonhole.x86_64-linux
        hydra.x86_64-linux
        ipxe.x86_64-linux
        ffmpeg-full.x86_64-linux
        fsatrace.x86_64-linux
        gawk_4_2_1.x86_64-linux
        ghcide.x86_64-linux
        libprelude.x86_64-linux
        libvmaf.x86_64-linux
        lorri.x86_64-linux
        nano.x86_64-linux
        netsniff-ng.x86_64-linux
        nixops.x86_64-linux
        ntp.x86_64-linux
        oauth2_proxy.x86_64-linux
        ppp-devel.x86_64-linux
        radare2.x86_64-linux
        terraform-provider-okta.x86_64-linux
        terraform-provider-vultr.x86_64-linux
        trimpcap.x86_64-linux
        tsoff.x86_64-linux
        unbound.x86_64-linux
        wpa_supplicant.x86_64-linux
        xtensa-esp32-toolchain.x86_64-linux

        emacs-nox-env.x86_64-linux
        haskell-env.x86_64-linux
        extensive-haskell-env.x86_64-linux

        minikube.x86_64-linux

        python-env.x86_64-linux

        maths-env.x86_64-linux
        minikube-env.x86_64-linux
        nixops-env.x86_64-linux
        nixtools-env.x86_64-linux
        opsec-env.x86_64-linux

        #hello-dhall-file.x86_64-linux
        #hello-dhall-src.x86_64-linux

        dhess-nix-source.x86_64-linux
      ];
    };

    x86_64-darwin = pkgs.releaseTools.aggregate {
      name = "dhess-nix-x86_64-darwin";
      meta.description = "dhess-nix overlay packages (x86_64-darwin)";
      meta.maintainer = lib.maintainers.dhess-pers;
      constituents = with jobs; [
        aws-okta.x86_64-darwin
        aws-sam-cli.x86_64-darwin

        badhosts-unified.x86_64-darwin
        badhosts-fakenews.x86_64-darwin
        badhosts-gambling.x86_64-darwin
        badhosts-porn.x86_64-darwin
        badhosts-social.x86_64-darwin
        badhosts-fakenews-gambling.x86_64-darwin
        badhosts-fakenews-porn.x86_64-darwin
        badhosts-fakenews-social.x86_64-darwin
        badhosts-gambling-porn.x86_64-darwin
        badhosts-gambling-social.x86_64-darwin
        badhosts-porn-social.x86_64-darwin
        badhosts-fakenews-gambling-porn.x86_64-darwin
        badhosts-fakenews-gambling-social.x86_64-darwin
        badhosts-fakenews-porn-social.x86_64-darwin
        badhosts-gambling-porn-social.x86_64-darwin
        badhosts-fakenews-gambling-porn-social.x86_64-darwin
        badhosts-all.x86_64-darwin

        ccextractor.x86_64-darwin
        cfssl.x86_64-darwin
        chamber.x86_64-darwin
        crosstool-ng-xtensa.x86_64-darwin
        dhess-ssh-keygen.x86_64-darwin
        ffmpeg-full.x86_64-darwin
        fm-assistant.x86_64-darwin
        fsatrace.x86_64-darwin
        gawk_4_2_1.x86_64-darwin
        ghcide.x86_64-darwin
        libvmaf.x86_64-darwin
        lorri.x86_64-darwin
        nano.x86_64-darwin
        nixops.x86_64-darwin
        radare2.x86_64-darwin
        terraform-provider-okta.x86_64-darwin
        terraform-provider-vultr.x86_64-darwin
        xtensa-esp32-toolchain.x86_64-darwin

        emacs-env.x86_64-darwin
        emacs-macport-env.x86_64-darwin
        haskell-env.x86_64-darwin
        extensive-haskell-env.x86_64-darwin

        ihaskell.x86_64-darwin
        ihaskell-env.x86_64-darwin
        ihaskell-envfun.x86_64-darwin
        extensive-ihaskell-env.x86_64-darwin
        extensive-ihaskell-envfun.x86_64-darwin

        hyperkit.x86_64-darwin
        minikube.x86_64-darwin

        python-env.x86_64-darwin

        anki-env.x86_64-darwin
        mactools-env.x86_64-darwin
        maths-env.x86_64-darwin
        minikube-env.x86_64-darwin
        nixops-env.x86_64-darwin
        nixtools-env.x86_64-darwin
        opsec-env.x86_64-darwin
        shell-env.x86_64-darwin

        #hello-dhall-file.x86_64-darwin
        #hello-dhall-src.x86_64-darwin

        dhess-nix-source.x86_64-darwin
      ];
    };

    aarch64-linux = pkgs.releaseTools.aggregate {
      name = "dhess-nix-aarch64-linux";
      meta.description = "dhess-nix overlay packages (aarch64-linux)";
      meta.maintainer = lib.maintainers.dhess-pers;
      constituents = with jobs; [
        cfssl.aarch64-linux
        haskell-env.aarch64-linux
        #extensive-haskell-env.aarch64-linux
      ];
    };
  });

in
jobs
