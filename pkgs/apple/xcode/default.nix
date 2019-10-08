{ stdenv, requireFile, lib }:

let requireXcode = version: sha256:
  let
    xip = "Xcode_" + version +  ".xip";
    # TODO(alexfmpe): Find out how to validate the .xip signature in Linux
    unxip = if stdenv.isDarwin
            then ''
              open -W ${xip}
              rm -rf ${xip}
            ''
            else ''
              xar -xf ${xip}
              rm -rf ${xip}
              pbzx -n Content | cpio -i
              rm Content Metadata
            '';
    app = requireFile rec {
      name     = "Xcode.app";
      url      = "https://download.developer.apple.com/Developer_Tools/Xcode_${version}/${xip}";
      hashMode = "recursive";
      inherit sha256;
      message  = ''
        Unfortunately, we cannot download ${name} automatically.
        Please go to ${url}
        to download it yourself, and add it to the Nix store by running the following commands.
        Note: download (~ 5GB), extraction and storing of Xcode will take a while

        ${unxip}
        nix-store --add-fixed --recursive sha256 Xcode.app
        rm -rf Xcode.app
      '';
    };
    meta = with stdenv.lib; {
      homepage = https://developer.apple.com/downloads/;
      description = "Apple's XCode SDK";
      license = licenses.unfree;
      platforms = platforms.darwin ++ platforms.linux;
    };

  in app.overrideAttrs ( oldAttrs: oldAttrs // { inherit meta; });

in lib.makeExtensible (self: {
  xcode_11_0 = requireXcode "11.0" "1r03j3kkp4blfp2kqpn538w3dx57ms930fj8apjkq6dk7fv3jcqh";
  xcode_11_1 = requireXcode "11.1" "1c2gzc4jhhx5a7ncg19sh1r99izhipybaqxl1ll52x5y8689awc1";
  xcode = self."xcode_${lib.replaceStrings ["."] ["_"] (if stdenv.targetPlatform.useiOSPrebuilt then stdenv.targetPlatform.xcodeVer else "11.1")}";
})
