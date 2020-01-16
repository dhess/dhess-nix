self: pkgs:

let

  ## Emacs package overrides.

  mkEmacsPackages = epkgs: epkgs.override (self: super: {

    # Add various formatting utilities to format-all.
    format-all = super.format-all.overrideAttrs (drv: {
      packageRequires = drv.packageRequires ++ (with pkgs; [
        asmfmt
        clang-tools
        haskellPackages.brittany
        html-tidy
        nixfmt
        nodePackages.prettier
        perlPackages.PerlTidy
        python37Packages.black
        python37Packages.sqlparse
        rustfmt
        shfmt
        terraform
        texlive.latexindent
      ]);
    });
  });

  emacs-nox = pkgs.emacs26-nox;

  emacsMelpaPackagesNg = pkgs.melpaPackagesNgFor (mkEmacsPackages pkgs.emacs);
  emacsMacportMelpaPackagesNg = pkgs.melpaPackagesNgFor (pkgs.emacsMacport);
  emacsNoXMelpaPackagesNg = pkgs.melpaPackagesNgFor (mkEmacsPackages emacs-nox);

  ## Collections of Emacs packages that I find useful.

  # A core set of packages that are useful everywhere.
  coreEmacsPackages = epkgs: with epkgs; [
    agda2-mode
    async
    auto-compile
    auto-complete
    company
    company-cabal
    company-coq
    company-lean
    company-lsp
    company-nixos-options
    company-terraform
    coq-commenter
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
    format-all
    go-mode
    haskell-mode
    hasklig-mode
    hindent
    hlint-refactor
    ido-describe-bindings
    ido-vertical-mode
    lean-mode
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
    proof-general
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

  # Mostly formatters for use with the format-all package.
  coreExternalPackages = with pkgs; [
    (aspellWithDicts (dicts: with dicts; [ en ]))
    ripgrep
  ];

  ## Package up various Emacs with coreEmacsPackages and the binaries
  ## needed to support them.

  # Vanilla emacs.
  emacs-env = pkgs.buildEnv {
    name = "emacs-env";

    # Yes, pkgs.emacsMacport here is intentional. Only build this for
    # macOS platforms.
    meta.platforms = pkgs.emacsMacport.meta.platforms;

    paths = [
      (emacsMelpaPackagesNg.emacsWithPackages coreEmacsPackages)
      coreExternalPackages
    ];
  };

  # "No X" variant.
  emacs-nox-env = pkgs.buildEnv {
    name = "emacs-nox-env";
    meta.platforms = emacs-nox.meta.platforms;
    paths = [
      (emacsNoXMelpaPackagesNg.emacsWithPackages coreEmacsPackages)
      coreExternalPackages
    ];
  };

  # An emacsMacport variant.
  emacs-macport-env = pkgs.buildEnv {
    name = "emacs-macport-env";
    meta.platforms = pkgs.emacsMacport.meta.platforms;
    paths = [
      (emacsMacportMelpaPackagesNg.emacsWithPackages coreEmacsPackages)
      coreExternalPackages
    ];
  };

in
{
  inherit emacsMelpaPackagesNg;
  inherit emacs-nox emacsNoXMelpaPackagesNg;
  inherit emacsMacportMelpaPackagesNg;
  inherit emacs-env emacs-nox-env emacs-macport-env;
}
