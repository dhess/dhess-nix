self: super:

let

  lib = import ../lib;

  inherit (super) callPackage;

  haskell-nix-pkgs = (import lib.fixedNixpkgs) (import lib.fixedHaskellNix);
  inherit (haskell-nix-pkgs) haskell-nix;

  # A list of "core" Haskell packages that I want to build for any
  # given release of this overlay.
  coreList = hp: with hp; [
    aeson
    alex
    async
    base-compat
    bytestring
    containers
    criterion
    cryptonite
    data-fix
    data-has
    deepseq
    directory
    doctest
    either
    errors
    exceptions
    fail
    filepath
    foldl
    folds
    generic-lens
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
    lens
    lens-aeson
    megaparsec
    mtl
    network
    network-bsd
    optparse-applicative
    optparse-text
    prettyprinter
    profunctors
    protolude
    QuickCheck
    quickcheck-instances
    recursion-schemes
    safe
    safe-exceptions
    semigroupoids
    semigroups
    semirings
    show-prettyprint
    singletons
    stm
    tasty
    tasty-hedgehog
    text
    time
    transformers
    transformers-base
    transformers-compat
    unix
    unix-bytestring
    unix-compat
    unordered-containers
    vector
    zippers
  ];

  # A list of extra packages that would be nice to build for any given
  # release of this overlay, but aren't showstoppers.
  extraList = hp: with hp; (coreList hp) ++ [
    Agda
    accelerate
    acid-state
    ad
    aeson-pretty
    algebra
    amazonka
    amazonka-ec2
    amazonka-route53
    amazonka-route53-domains
    amazonka-s3
    amazonka-sns
    amazonka-sqs
    approximate
    attoparsec
    auto
    autoexporter
    auto-update
    bifunctors
    binary
    bits
    boring
    bytes
    blaze-html
    blaze-markup
    bloodhound
    clay
    cereal
    charset
    comonad
    cond
    conduit
    concurrent-machines
    conduit-combinators
    configurator
    configuration-tools
    contravariant
    constraints
    dhall-nix
    dhall
    dhall-json
    distributive
    doctest-driver-gen
    fgl
    fmt
    formatting
    free
    gdp
    GraphSCC
    groupoids
    graphs
    hal
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
    hw-json-simd
    intervals
    ip
    iproute
    ivory
    justified-containers
    kan-extensions
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
    managed
    memory
    monad-control
    monad-logger
    monad-logger-syslog
    mustache
    neat-interpolation
    numeric-extras
    path
    path-io
    parsers
    parsec
    pipes-attoparsec
    pipes-errors
    pipes-group
    pipes
    pipes-bytestring
    pipes-safe
    process
    process-streaming
    reducers
    reflection
    resourcet
    regex-applicative
    repline
    safecopy
    sbv
    servant
    servant-client
    servant-docs
    servant-lucid
    servant-server
    servant-swagger
    servant-swagger-ui
    shake
    shelly
    smtLib
    stm-containers
    streams
    streaming
    streaming-bytestring
    streaming-utils
    strict
    swagger2
    tagged
    tar
    tasty-hunit
    temporary
    time-recurrence
    trifecta
    turtle
    type-of-html
    uniplate
    vector-instances
    wai
    wai-extra
    warp
    webdriver
    zlib-lens
  ];

  ## Create a buildEnv with useful Haskell tools, the given set of
  ## haskell-nix packages, and a list of packages to install in the
  ## buildEnv.

  mkHaskellNixBuildEnv = name: hp: packageList:
  let
    paths =  [
        (hp.ghcWithHoogle packageList)
        #(all-hies.selection { selector = p: { inherit (p) ghc865; }; })
        #ghcide
        # (exeOnly hp.cabal-install)
        # (exeOnly hp.hpack)
        # (exeOnly hp.structured-haskell-mode)
        # (exeOnly hp.stylish-haskell)
        # (exeOnly hp.brittany)
    ];
  in
  super.buildEnv
    {
      inherit name paths;
      # XXX dhess - Hack. haskell-nix.haskellPackages.ghc.meta is missing.
      meta.platforms = ["x86_64-linux" "x86_64-darwin" "aarch64-linux"];
    };

  haskell-nix-env = mkHaskellNixBuildEnv "haskell-nix-env" haskell-nix.haskellPackages coreList;

in
{
  inherit haskell-nix;
  inherit (haskell-nix) nix-tools;

  inherit haskell-nix-env;
}
