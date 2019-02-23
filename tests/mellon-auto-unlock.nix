{ system ? "x86_64-linux"
, pkgs
, makeTest
, ...
}:

let

in makeTest rec {
  name = "mellon-auto-unlock";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ dhess-pers ];
  };

  nodes = {
    client = { config, ... }: {
      nixpkgs.localSystem.system = system;
      imports = pkgs.lib.dhess-nix.modules;
      services.mellon-auto-unlock.locks.front-door = {
        description = "Front door daily auto-unlock";
        mellonUrl = "http://localhost";
        unlockTime = "04:00";
        lockTimeTZ = "Etc/UTC";
        lockTime = "4:00pm today";
      };
    };
  };

  testScript = { nodes, ... }:
  ''
    startAll;
    $client->waitForUnit("mellon-auto-unlock\@front-door.timer");
  '';
}
