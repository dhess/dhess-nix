{ stdenv
, lib
, cacert
, pkgs
, extraCerts ? {}
}:

let

  extraCAs = pkgs.writeText "extraCAs"
  (lib.concatStrings
    (lib.mapAttrsToList
      (caName: caPem:
        ''
          ${caName}
          ${caPem}
        '')
      extraCerts));

in
cacert.overrideAttrs (oldAttrs: {

  installPhase = ''
    mkdir -pv $out/etc/ssl/certs
    cat ca-bundle.crt ${extraCAs} > $out/etc/ssl/certs/ca-bundle.crt
  '';

})
