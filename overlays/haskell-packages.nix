self: super:

let

  inherit (super) stdenv;
  inherit (super.haskell.lib) doJailbreak dontCheck properExtend;


  ## Useful functions.

  exeOnly = super.haskell.lib.justStaticExecutables;


  ## Haskell package fixes for various versions of GHC, based on the
  ## current nixpkgs snapshot that we're using.

  # The current GHC.
  haskellPackages = properExtend super.haskellPackages (self: super: {
    algebra = doJailbreak super.algebra;
    bloodhound = doJailbreak super.bloodhound;
    clay = doJailbreak super.clay;
    dhall = dontCheck super.dhall_1_20_1;
    dhall-to-cabal = doJailbreak super.dhall-to-cabal;
    dhess-ssh-keygen = doJailbreak (super.callPackage ../pkgs/haskell/dhess-ssh-keygen {});
    fm-assistant = dontCheck (super.callPackage ../pkgs/haskell/fm-assistant {});
    hoopl = doJailbreak super.hoopl;
    hw-balancedparens = doJailbreak super.hw-balancedparens;
    hw-bits = doJailbreak super.hw-bits;
    hw-excess = doJailbreak super.hw-excess;
    hw-json = doJailbreak super.hw-json;
    hw-json-lens = doJailbreak super.hw-json-lens;
    hw-prim = doJailbreak super.hw-prim;
    hw-rankselect = doJailbreak super.hw-rankselect;
    hw-rankselect-base = doJailbreak super.hw-rankselect-base;
    insert-ordered-containers = doJailbreak super.insert-ordered-containers;
    ivory = doJailbreak super.ivory;
    katip = super.katip_0_8_0_0.overrideAttrs (drv: {
      meta.hydraPlatforms = stdenv.lib.platforms.all;
    });
    katip-elasticsearch = dontCheck super.katip-elasticsearch;
    machines-process = doJailbreak super.machines-process;

    # Nixpkgs is currently forcing pandoc to 2.7, but that breaks some
    # things.
    pandoc = dontCheck (super.callPackage ../pkgs/haskell/pandoc/2.5.nix {});

    pandoc-citeproc = doJailbreak (super.pandoc-citeproc.overrideAttrs (drv: {
      meta.hydraPlatforms = stdenv.lib.platforms.all;
    }));
    pipes-errors = doJailbreak super.pipes-errors;
    pipes-text = doJailbreak super.pipes-text;
    pipes-transduce = dontCheck super.pipes-transduce;
    servant-docs = doJailbreak super.servant-docs;
    streaming-utils = doJailbreak super.streaming-utils;
    tdigest = doJailbreak super.tdigest;
    these = doJailbreak super.these;
    time-recurrence = doJailbreak super.time-recurrence;
    wires = doJailbreak super.wires;
  });

  # GHC 8.4.4.
  ghc844Packages = properExtend super.haskell.packages.ghc844 (self: super:
    {
      Diff = dontCheck super.Diff;

      # Needs to be called with flags for GHC 8.4.4.
      aeson = doJailbreak (super.callPackage ../pkgs/haskell/aeson {});

      cereal = dontCheck super.cereal;

      darcs = doJailbreak (super.darcs.overrideAttrs (drv: {
        meta.hydraPlatforms = stdenv.lib.platforms.all;
      }));

      insert-ordered-containers = doJailbreak super.insert-ordered-containers;
      these = doJailbreak super.these;
    }
  );


  ## Package sets that I want to be built.

  # A list of currently-problematic packages, things that can't easily
  # be fixed by overrides.
  problems = hp: with hp; [
    Lykah
    blazeT
    concurrent-machines
    dhall-nix
    haxl-amazonka
    hnix
    hspec-webdriver
    parsec-free
    pipes-shell
    pipes-zlib
    stm-containers
    uniqueid
  ];

  mkInstalledPackages = desired: problems: hp:
    super.lib.subtractLists (problems hp) (desired hp);

  # A list of "core" Haskell packages that I want to build for any
  # given release of this overlay.
  coreList = hp: with hp; [
    acid-state
    aeson
    aeson-iproute
    aeson-pretty
    alex
    algebra
    async
    attoparsec
    base-compat
    bifunctors
    binary
    bits
    bytes
    bytestring
    cereal
    charset
    comonad
    cond
    conduit
    containers
    contravariant
    criterion
    cryptonite
    data-has
    deepseq
    dhall
    dhall-json
    dhall-nix
    directory
    distributive
    doctest
    either
    errors
    exceptions
    fail
    filepath
    foldl
    folds
    free
    generic-lens
    groupoids
    happy
    haskeline
    hlint
    hscolour
    hspec
    hspec-expectations-lens
    hspec-megaparsec
    hspec-wai
    http-api-data
    http-client
    http-client-tls
    http-types
    inline-c
    iproute
    kan-extensions
    lens
    lens-aeson
    managed
    megaparsec
    monad-control
    monad-log
    monad-logger
    monad-logger-syslog
    mtl
    network
    network-attoparsec
    optparse-applicative
    optparse-text
    pandoc
    parsec
    parsers
    path
    path-io
    pipes
    pipes-bytestring
    pipes-safe
    prettyprinter
    profunctors
    protolude
    QuickCheck
    quickcheck-instances
    recursion-schemes
    reflection
    resourcet
    safe
    safe-exceptions
    semigroupoids
    semigroups
    servant
    servant-client
    servant-docs
    servant-lucid
    servant-server
    servant-swagger
    servant-swagger-ui
    show-prettyprint
    singletons
    stm
    streaming
    streaming-bytestring
    streaming-utils
    strict
    swagger2
    tasty
    text
    time
    transformers
    transformers-base
    transformers-compat
    trifecta
    unix
    unix-bytestring
    unix-compat
    unordered-containers
    vector
    vector-instances
    wai
    wai-extra
    warp
    zippers
  ];

  # A combinator that takes a haskellPackages and returns a list of
  # core packages that we want built from that haskellPackages set,
  # minus any problematic packages.
  coreHaskellPackages = mkInstalledPackages coreList problems;


  # A list of extra packages that would be nice to build for any given
  # release of this overlay, but aren't showstoppers.
  extraList = hp: with hp; (coreList hp) ++ [
    accelerate
    ad
    amazonka
    amazonka-ec2
    amazonka-route53
    amazonka-route53-domains
    amazonka-s3
    amazonka-sns
    amazonka-sqs
    auto
    autoexporter
    auto-update
    blaze-html
    blaze-markup
    blazeT
    bloodhound
    clay
    concurrent-machines
    conduit-combinators
    configurator
    configuration-tools
    constraints
    fgl
    formatting
    GraphSCC
    hakyll
    haxl
    haxl-amazonka
    hex
    hnix
    hoopl
    hspec-webdriver
    hw-json
    hw-json-lens
    intervals
    ivory
    katip
    katip-elasticsearch
    lens-action
    lifted-async
    lifted-base
    linear
    linear-accelerate
    list-t
    llvm-hs-pure
    lucid
    Lykah
    lzma
    machines
    machines-binary
    machines-directory
    machines-io
    machines-process
    memory
    numeric-extras
    parsec-free
    pipes-attoparsec
    pipes-errors
    pipes-group
    pipes-shell
    pipes-zlib
    process
    process-streaming
    reducers
    regex-applicative
    repline
    safecopy
    sbv
    shelly
    smtLib
    stm-containers
    tar
    tasty-hunit
    temporary
    thyme
    time-recurrence
    turtle
    uniplate
    uniqueid
    webdriver
    wires
    zlib-lens
  ];

  # A combinator that takes a haskellPackages and returns a list of
  # extensive packages that we want built from that haskellPackages
  # set, minus any problematic packages.
  extensiveHaskellPackages = mkInstalledPackages extraList problems;


  ## Custom package sets for things that need particular package versions.

  dhall-nix-packages = properExtend ghc844Packages (self: super:
    {
      # dhall runs network tests.
      dhall = dontCheck (doJailbreak (super.callPackage ../pkgs/haskell/dhall/1.17.0.nix {}));

      dhall-nix = super.dhall-nix.overrideAttrs (drv: {
        meta.hydraPlatforms = stdenv.lib.platforms.all;
      });

      megaparsec = dontCheck super.megaparsec_6_5_0;

      neat-interpolation = super.callPackage ../pkgs/haskell/neat-interpolation/0.3.2.2.nix {};

      repline = super.callPackage ../pkgs/haskell/repline/0.1.7.0.nix {};
    }
  );


  ## Create a buildEnv with useful Haskell tools and the given set of
  ## haskellPackages and a list of packages to install in the
  ## buildEnv.

  mkHaskellBuildEnv = name: hp: packageList:
  let
    paths =  [
        (hp.ghcWithHoogle packageList)
        (exeOnly hp.cabal-install)
        (exeOnly hp.dhall-to-cabal)
        (exeOnly hp.hindent)
        (exeOnly hp.hpack)
        (exeOnly hp.structured-haskell-mode)
        (exeOnly hp.stylish-haskell)
    ];
  in
  super.buildEnv
    {
      inherit name paths;
      meta.platforms = hp.ghc.meta.platforms;
    };

  haskell-env = mkHaskellBuildEnv "haskell-env" haskellPackages coreHaskellPackages;  
  extensive-haskell-env = mkHaskellBuildEnv "extensive-haskell-env" haskellPackages extensiveHaskellPackages;  

in
{
  inherit haskellPackages;


  ## Haskell package combinators.

  inherit coreHaskellPackages;
  inherit extensiveHaskellPackages;


  ## Haskell buildEnv's.

  inherit mkHaskellBuildEnv;
  inherit haskell-env;
  inherit extensive-haskell-env;

  ## Executables only.

  darcs = exeOnly ghc844Packages.darcs;

  dhall-nix = exeOnly dhall-nix-packages.dhall-nix;

  dhess-ssh-keygen = exeOnly self.haskellPackages.dhess-ssh-keygen;

  fm-assistant = exeOnly self.haskellPackages.fm-assistant;

  mellon-gpio = exeOnly self.haskellPackages.mellon-gpio;

  mellon-web = exeOnly self.haskellPackages.mellon-web;

  # Disable tests on the static executable; something in the doctests
  # causes a nasty (internal?) GHC bug.
  pinpon = exeOnly (self.haskellPackages.pinpon);
}
