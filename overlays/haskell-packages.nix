self: super:

let

  localLib = import ../lib;

  inherit (super) stdenv fetchpatch;
  inherit (super.haskell.lib) appendPatch doJailbreak dontCheck dontHaddock properExtend;


  ## Useful functions.

  exeOnly = super.haskell.lib.justStaticExecutables;


  ## Haskell package fixes for various versions of GHC, based on the
  ## current nixpkgs snapshot that we're using.

  # The current GHC.
  haskellPackages = properExtend super.haskellPackages (self: super: {
    acid-state = doJailbreak super.acid-state;
    algebra = doJailbreak super.algebra;
    bloodhound = doJailbreak super.bloodhound;
    clay = doJailbreak super.clay;
    connection = super.connection_0_3_0;
    concurrent-machines = doJailbreak super.concurrent-machines;

    # dhall tests try to hit the network.
    dhall = dontCheck super.dhall_1_24_0;

    # Tests are broken upstream, but package is fine.
    dhall-json = dontCheck super.dhall-json_1_3_0;

    # The new dhall-nix hasn't been pushed to Hackage yet.
    dhall-nix = super.callPackage ../pkgs/haskell/dhall-nix {};

    dhall-to-cabal = doJailbreak super.dhall-to-cabal;

    dhess-ssh-keygen = doJailbreak (super.callPackage ../pkgs/haskell/dhess-ssh-keygen {});

    doctest-driver-gen = dontCheck (super.doctest-driver-gen.overrideAttrs (drv: {
      broken = false;
      meta.hydraPlatforms = stdenv.lib.platforms.all;
    }));

    fm-assistant = dontCheck (super.callPackage ../pkgs/haskell/fm-assistant {});

    # Ironically, haddock-api doesn't haddock.
    haddock-api =  dontHaddock (doJailbreak super.haddock-api);

    haddocset = super.callPackage ../pkgs/haskell/haddocset {};
    hedgehog = super.hedgehog_1_0;
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
    ip = super.callPackage ../pkgs/haskell/ip {};
    ivory = doJailbreak super.ivory;
    katip = super.katip_0_8_2_0.overrideAttrs (drv: {
      meta.hydraPlatforms = stdenv.lib.platforms.all;
    });
    katip-elasticsearch = dontCheck super.katip-elasticsearch;
    hfsevents = super.hfsevents.overrideAttrs (drv: {
      meta.hydraPlatforms = stdenv.lib.platforms.darwin;
    });
    machines-process = doJailbreak super.machines-process;
    network = super.network_3_1_0_0;
    network-bsd = super.network-bsd_2_8_1_0;

    pandoc-citeproc = doJailbreak (super.pandoc-citeproc.overrideAttrs (drv: {
      meta.hydraPlatforms = stdenv.lib.platforms.all;
    }));

    # Disable tests on aarch64-linux; the doctests cause an internal error.
    pinpon = if stdenv.hostPlatform.isAarch64 then dontCheck super.pinpon else super.pinpon;

    pipes-errors = doJailbreak super.pipes-errors;
    pipes-text = doJailbreak super.pipes-text;
    pipes-transduce = dontCheck super.pipes-transduce;
    primitive-extras = super.callPackage ../pkgs/haskell/primitive-extras/0.7.1.1.nix {};
    primitive-unlifted = dontCheck (doJailbreak super.primitive-unlifted);
    semirings = super.callPackage ../pkgs/haskell/semirings/0.3.1.2.nix {};
    servant-docs = doJailbreak super.servant-docs;
    socks = super.socks_0_6_0;
    swagger2 = super.swagger2_2_4;
    stm-hamt = doJailbreak super.stm-hamt;
    stratosphere = super.stratosphere_0_39_0;
    stream-monad = doJailbreak super.stream-monad;
    streaming-utils = doJailbreak super.streaming-utils;
    tdigest = doJailbreak super.tdigest;
    these = doJailbreak super.these;
    time-recurrence = doJailbreak super.time-recurrence;

    # Disable tests on aarch64-linux; the doctests cause an internal error.
    trifecta = if stdenv.hostPlatform.isAarch64 then dontCheck super.trifecta else super.trifecta;

    wide-word = doJailbreak super.wide-word;
    wires = doJailbreak super.wires;

    # Disable tests on aarch64-linux; the doctests cause an internal error.
    zippers = if stdenv.hostPlatform.isAarch64 then dontCheck super.zippers else super.zippers;
  });


  ## Package sets that I want to be built.

  # A list of currently-problematic packages, things that can't easily
  # be fixed by overrides.
  problems = hp: with hp; [
    hakyll
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
    boring
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
    data-fix
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
    haddocset
    happy
    haskeline
    hedgehog
    hedgehog-quickcheck
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
    tasty-hedgehog
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
    Agda
    accelerate
    ad
    amazonka
    amazonka-ec2
    amazonka-route53
    amazonka-route53-domains
    amazonka-s3
    amazonka-sns
    amazonka-sqs
    approximate
    auto
    autoexporter
    auto-update
    blaze-html
    blaze-markup
    bloodhound
    clay
    concurrent-machines
    conduit-combinators
    configurator
    configuration-tools
    constraints
    doctest-driver-gen
    fgl
    fmt
    formatting
    GraphSCC
    graphs
    hakyll
    haxl
    hedgehog-classes
    hedgehog-corpus
    hedgehog-fn
    hex
    hnix
    hoopl
    hw-hedgehog
    hw-hspec-hedgehog
    hw-json
    hw-json-lens
    intervals
    ip
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
    lzma
    machines
    machines-binary
    machines-directory
    machines-io
    machines-process
    memory
    neat-interpolation
    numeric-extras
    pipes-attoparsec
    pipes-errors
    pipes-group
    process
    process-streaming
    reducers
    regex-applicative
    repline
    safecopy
    sbv
    semirings
    shelly
    smtLib
    stratosphere
    stm-containers
    streams
    tagged
    tar
    tasty-hunit
    temporary
    thyme
    time-recurrence
    turtle
    uniplate
    webdriver
    wires
    zlib-lens
  ];

  # A combinator that takes a haskellPackages and returns a list of
  # extensive packages that we want built from that haskellPackages
  # set, minus any problematic packages.
  extensiveHaskellPackages = mkInstalledPackages extraList problems;

  # haskell-ide-engine via all-hies.
  inherit (localLib) all-hies;

  ## Create a buildEnv with useful Haskell tools and the given set of
  ## haskellPackages and a list of packages to install in the
  ## buildEnv.

  mkHaskellBuildEnv = name: hp: packageList:
  let
    paths =  [
        (hp.ghcWithHoogle packageList)
        (all-hies.unstableFallback.selection { selector = p: { inherit (p) ghc865; }; })
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

  ## haskell-ide-engine.

  inherit all-hies;

  ## Executables only.

  dhall-nix = exeOnly self.haskellPackages.dhall-nix;

  dhess-ssh-keygen = exeOnly self.haskellPackages.dhess-ssh-keygen;

  fm-assistant = exeOnly self.haskellPackages.fm-assistant;

  mellon-gpio = exeOnly self.haskellPackages.mellon-gpio;

  mellon-web = exeOnly self.haskellPackages.mellon-web;

  pinpon = exeOnly self.haskellPackages.pinpon;
}
