self: pkgs:

let

  emacs-nox = pkgs.emacs26-nox;

  # Note: these use Melpa packages.
  emacsMacportPackagesNg = pkgs.melpaPackagesNgFor pkgs.emacsMacport;
  emacsNoXPackagesNg = pkgs.melpaPackagesNgFor emacs-nox;


  ## Collections of Emacs packages that I find useful.

  # A core set of packages that are useful everywhere.
  coreEmacsPackages = epkgs: with epkgs; [
    async
    auto-compile
    auto-complete
    company
    company-cabal
    company-nixos-options
    company-terraform
    counsel
    counsel-projectile
    dante
    dash
    deadgrep
    dhall-mode
    direnv
    elpy
    find-file-in-project
    flx-ido
    flycheck
    flycheck-haskell
    go-mode
    haskell-mode
    hindent
    hlint-refactor
    ido-describe-bindings
    ido-vertical-mode
    magit
    magit-popup
    markdown-mode
    nix-mode
    nix-sandbox
    nixos-options
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

  # "No X" variant.
  emacs-nox-env = pkgs.buildEnv {
    name = "emacs-nox-env";
    meta.platforms = emacs-nox.meta.platforms;
    paths = [
      (emacsNoXPackagesNg.emacsWithPackages coreEmacsPackages)
      pkgs.aspell
      pkgs.aspellDicts.en
      pkgs.ripgrep
    ];
  };

  # A macOS variant.
  emacs-macport-env = pkgs.buildEnv {
    name = "emacs-macport-env";
    meta.platforms = pkgs.emacsMacport.meta.platforms;
    paths = [
      (emacsMacportPackagesNg.emacsWithPackages macOSEmacsPackages)
      pkgs.aspell
      pkgs.aspellDicts.en
      pkgs.ripgrep
    ];
  };

in
{
  inherit emacs-nox emacsNoXPackagesNg;
  inherit emacsMacportPackagesNg;
  inherit emacs-nox-env emacs-macport-env;
}
