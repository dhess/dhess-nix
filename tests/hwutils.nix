{ system ? "x86_64-linux"
, pkgs
, makeTest
, ...
}:

let

in makeTest rec {
  name = "hwutils";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ dhess-pers ];
  };

  machine = { config, ... }: {
    nixpkgs.localSystem.system = system;
    imports = pkgs.lib.dhess-nix.modules;
    quixops.hardware.hwutils.enable = true;
  };

  testScript = { nodes, ... }:
  ''
    $machine->waitForUnit("multi-user.target");

    subtest "check-lspci", sub {
      $machine->succeed("lspci");
    };

    subtest "check-lsusb", sub {
      $machine->succeed("lsusb");
    };
  '';
}
