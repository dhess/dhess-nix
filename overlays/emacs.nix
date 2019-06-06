self: pkgs:

let

  emacs-nox = pkgs.emacs26-nox;

  emacsMelpaPackagesNg = pkgs.melpaPackagesNgFor pkgs.emacs;
  emacsMacportMelpaPackagesNg = pkgs.melpaPackagesNgFor pkgs.emacsMacport;
  emacsNoXMelpaPackagesNg = pkgs.melpaPackagesNgFor emacs-nox;


  ## Collections of Emacs packages that I find useful.

  # A core set of packages that are useful everywhere.
  coreEmacsPackages = epkgs: with epkgs; [
    async
    auto-compile
    auto-complete
    company
    company-box
    company-cabal
    company-lsp
    company-nixos-options
    company-terraform
    counsel
    counsel-projectile
    dante
    dap-mode
    dash
    deadgrep
    dhall-mode
    direnv
    doom-themes
    elpy
    find-file-in-project
    flx-ido
    flycheck
    flycheck-haskell
    go-mode
    haskell-mode
    hasklig-mode
    hindent
    hlint-refactor
    ido-describe-bindings
    ido-vertical-mode
    lsp-haskell
    lsp-mode
    lsp-ui
    magit
    magit-popup
    markdown-mode
    nix-mode
    nix-sandbox
    nixos-options
    org-journal
    org-plus-contrib
    org-ref
    paredit
    popup
    projectile
    projectile-ripgrep
    rg
    ripgrep
    shm
    smex
    solaire-mode
    terraform-mode
    use-package
    web-mode
    yaml-mode
    yasnippet
    znc
  ];

  # The core set, plus a few macOS-specific packages.
  macOSEmacsPackages = epkgs: (with epkgs; [
    dash-at-point
  ]) ++ (coreEmacsPackages epkgs);


  ## Package up various Emacs with coreEmacsPackages and the binaries
  ## needed to support them.

  # Vanilla emacs.
  emacs-env = pkgs.buildEnv {
    name = "emacs-env";

    # Yes, pkgs.emacsMacport here is intentional. Only build this for
    # macOS platforms.
    meta.platforms = pkgs.emacsMacport.meta.platforms;

    paths = [
      (emacsMelpaPackagesNg.emacsWithPackages macOSEmacsPackages)
      pkgs.aspell
      pkgs.aspellDicts.en
      pkgs.ripgrep
    ];
  };

  # "No X" variant.
  emacs-nox-env = pkgs.buildEnv {
    name = "emacs-nox-env";
    meta.platforms = emacs-nox.meta.platforms;
    paths = [
      (emacsNoXMelpaPackagesNg.emacsWithPackages coreEmacsPackages)
      pkgs.aspell
      pkgs.aspellDicts.en
      pkgs.ripgrep
    ];
  };

  # An emacsMacport variant.
  emacs-macport-env = pkgs.buildEnv {
    name = "emacs-macport-env";
    meta.platforms = pkgs.emacsMacport.meta.platforms;
    paths = [
      (emacsMacportMelpaPackagesNg.emacsWithPackages macOSEmacsPackages)
      pkgs.aspell
      pkgs.aspellDicts.en
      pkgs.ripgrep
    ];
  };

in
{
  inherit emacsMelpaPackagesNg;
  inherit emacs-nox emacsNoXMelpaPackagesNg;
  inherit emacsMacportMelpaPackagesNg;
  inherit emacs-env emacs-nox-env emacs-macport-env;
}
