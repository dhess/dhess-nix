{ stdenv, fetchurl, substituteAll, libpcap }:

stdenv.mkDerivation rec {
  version = "2.4.7";
  name = "ppp-${version}";

  src = fetchurl {
    url = "mirror://samba/ppp/${name}.tar.gz";
    sha256 = "0c7vrjxl52pdwi4ckrvfjr08b31lfpgwf3pp0cqy76a77vfs7q02";
  };

  patches =
    [ ( substituteAll {
        src = ./nix-purity.patch;
        inherit libpcap;
        glibc = stdenv.cc.libc.dev or stdenv.cc.libc;
      })
      # Without nonpriv.patch, pppd --version doesn't work when not run as
      # root.
      ./nonpriv.patch

      # Debian patches.

      # merged in upstream Git, but not yet released
      #./debian/patches/0001-abort-on-errors-in-subdir-builds.patch
      #./debian/patches/0002-pppd-add-support-for-defaultroute-metric-option.patch
      # ./debian/patches/0003-scripts-Avoid-killing-wrong-pppd.patch
      # ./debian/patches/0004-pppd-Fix-sign-extension-when-displaying-bytes-in-oct.patch
      # ./debian/patches/0005-Suppress-false-error-message-on-PPPoE-disconnect.patch
      # ./debian/patches/0006-Send-PADT-on-PPPoE-disconnect.patch
      # ./debian/patches/0007-pppd-ipxcp-Prevent-buffer-overrun-on-remote-router-n.patch
      # ./debian/patches/0008-pppd-Fix-ccp_options.mppe-type.patch
      # ./debian/patches/0009-pppd-Fix-ccp_cilen-calculated-size-if-both-deflate_c.patch
      # ./debian/patches/0010-Fix-a-typo-in-comment.-Diff-from-Yuuichi-Someya.patch
      # ./debian/patches/0011-plog-count-only-relevant-lines-from-syslog.patch
      # ./debian/patches/0012-Change-include-from-sys-errno.h-to-errno.h.patch
      ./debian/patches/0013-pppd-allow-use-of-arbitrary-interface-names.patch
      # ./debian/patches/0014-pppd-Remove-unused-declaration-of-ttyname.patch
      # ./debian/patches/0015-pppd-Provide-error-implementation-in-pppoe-discovery.patch
      ./debian/patches/0016-pppoe-include-netinet-in.h-before-linux-in.h.patch

      # # to be merged upstream
      # ./debian/patches/adaptive_echos
      # #./debian/patches/makefiles_cleanup
      # ./debian/patches/close_dev_ppp
      # ./debian/patches/chat_man
      # ./debian/patches/fix_linkpidfile
      # #./debian/patches/pppdump_use_zlib
      # ./debian/patches/pppoatm_resolver_light
      # ./debian/patches/pppoatm_cleanup
      # ./debian/patches/pppoe_noads
      # ./debian/patches/readable_connerrs
      # ./debian/patches/radius-config.c-unkown-typo

      # # github pull requests
      # ./debian/patches/pr-28-pppoe-custom-host-uniq-tag.patch

      # # not ready to be merged
      # ./debian/patches/011_scripts_redialer.diff
      # ./debian/patches/cifdefroute.dif
      # ./debian/patches/ppp-2.3.11-oedod.dif
      # ./debian/patches/radius_mtu

      # # rejected by the upstream maintainer
      # ./debian/patches/018_ip-up_option.diff
      # ./debian/patches/ppp-2.4.2-stripMSdomain
      # ./debian/patches/setenv_call_file

      # ./debian/patches/ipv6-accept-remote
      # ./debian/patches/ppp-2.4.4-strncatfix.patch

      # # debian-specific
      # ./debian/patches/010_scripts_README.diff
      # #./debian/patches/no_crypt_hack
      # ./debian/patches/resolv.conf_no_log
      # #./debian/patches/zzz_config
      # #./debian/patches/secure-card-interpreter-fix
      ./debian/patches/rc_mksid-no-buffer-overflow
      # #./debian/patches/pppd-soname-hack.patch
      # #./debian/patches/eaptls-mppe.patch
      # #./debian/patches/replace-vendored-hash-functions.patch

      # NixOS patches resume here      
      ./musl-fix-headers.patch
    ];

  buildInputs = [ libpcap ];

  postPatch = ''
    # strip is not found when cross compiling with seemingly no way to point
    # make to the right place, fixup phase will correctly strip
    # everything anyway so we remove it from the Makefiles
    for file in $(find -name Makefile.linux); do
      substituteInPlace "$file" --replace '$(INSTALL) -s' '$(INSTALL)'
    done
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    make install
    install -D -m 755 scripts/{pon,poff,plog} $out/bin
    runHook postInstall
  '';

  postFixup = ''
    for tgt in pon poff plog; do
      substituteInPlace "$out/bin/$tgt" --replace "/usr/sbin" "$out/bin"
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://ppp.samba.org/;
    description = "Point-to-point implementation for Linux and Solaris";
    license = with licenses; [ bsdOriginal publicDomain gpl2 lgpl2 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.falsifian ];
  };
}
