self: super:

let

  inherit (super) callPackage linuxPackagesFor;
  inherit (self) kernelPatches;

in
{
}
