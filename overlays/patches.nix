self: super:

let

in
{
  # cleverca22's patch for ntpd seccomp fixes. See:
  # https://github.com/ntp-project/ntp/pull/27
  # https://github.com/cleverca22/nixos-configs/blob/535e75d8a875da64c95ba12233432b584a19bef5/ntp_fix.nix
  #
  # I believe this should fix the issues I've been having with ntpd
  # going defunct and not being restarted properly.

  ntp = super.ntp.overrideAttrs (drv: {
    patches = [
      (self.fetchpatch {
        url = "https://github.com/ntp-project/ntp/commit/881e427f3236046466bdb8235edf86e6dfa34391.patch";
        sha256 = "0iqn12m7vzsblqbds5jb57m8cjs30rw8nh2xv8k2g8lbqbyk1k7s"; }) ];
    });


  # Hydra fixes from iohk.
  hydra = (super.callPackage ../pkgs/hydra {}).overrideAttrs (drv: {
    patches = [
      (super.fetchpatch {
        url = "https://github.com/input-output-hk/hydra/commit/ed87d2ba82807d30d91d70a88cda276083ef4e79.patch";
        sha256 = "0mzmm480cs085wbbn1ha6ml164v0dslfh0viak73mc84rvl00ckb";
      })
      (super.fetchpatch {
        url = "https://github.com/input-output-hk/hydra/commit/96ec35acface848c546b67e6b835094412a488d9.patch";
        sha256 = "0ax4bn1ivk5yg5mbdkcqbqc2vrjlyk9km2rzg1k1kqc81ka570a2";
      })
      (super.fetchpatch {
        url = "https://github.com/input-output-hk/hydra/commit/11db34b6a9243a428b3d5935c65ac13a8080d02c.patch";
        sha256 = "10b9ywif14gncf1j9647hhpbqh67yy0pv1c8f38f08v68a83993s";
      })
      (super.fetchpatch {
        url = "https://github.com/input-output-hk/hydra/commit/0768891e3cd3ef067d28742098f1dea8462fca75.patch";
        sha256 = "0m4009pmi4sl0vwq6q98bzp4hpnfr4ww1j27czwcazbda7l8fdzy";
      })
    ];
  });
}
