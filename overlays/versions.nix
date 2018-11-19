self: super:

let

  inherit (super) callPackage;

in
{
  rspamd = callPackage ../pkgs/email/rspamd {};
}
