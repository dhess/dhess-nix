{ system ? "armv7l-linux"
, pkgs
, makeTest
, ...
}:


let

  makeBBOverlaysTest = name: machineAttrs:
    makeTest {
      name = "bb-org-overlays-${name}";
      meta = with pkgs.lib.maintainers; {
        maintainers = [ dhess-pers ];
      };
      machine = { config, ... }: {
        nixpkgs.localSystem.system = system;

        imports = [
          ./common/users.nix
        ] ++ pkgs.lib.dhess-nix.modules;
      } // machineAttrs;
      testScript = { nodes, ... }:
      let
        pkgs = nodes.machine.pkgs;
      in
      ''
        $machine->waitForUnit("multi-user.target");

        subtest "config-pin", sub {
          $machine->succeed("${pkgs.bb-org-overlays}/bin/config-pin -v");
        };
      '';
    };

in
{

  defaultTest = makeBBOverlaysTest "default" { };

}
