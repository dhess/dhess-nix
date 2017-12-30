self: super:

let

in rec
{

  # jemalloc fails test_pages_huge on armv7l.
  jemalloc = if super.stdenv.system == "armv7l-linux"
  then
    super.jemalloc.overrideAttrs (oldAttrs : {
      doCheck = false;
    })
  else
    super.jemalloc;

}
