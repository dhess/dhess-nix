self: super:

let

  inherit (super) callPackage;

  xcode = callPackage ../pkgs/apple/xcode {};

  darwin = super.darwin // {
     inherit (xcode) xcode xcode_11_0;
  };

in
{
  inherit (xcode) xcode xcode_11_0;
  inherit darwin;
}
