self: super:

let

in rec
{
  gitaly = super.gitaly.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or []) ++ [ ../pkgs/patches/gitaly.patch ];
  });
}
