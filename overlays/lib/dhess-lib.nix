self: super:

let

  # Provide access to the whole package, if needed.
  path = ../..;


  # A list of all the NixOS modules exported by this package.
  modulesList = ../../modules/module-list.nix;


  # All NixOS modules exported by this package. To use, add this
  # expression to your configuration's list of imports.
  modules = import modulesList;


  # Create the text of a znc config file, so that it can be securely
  # deployed to a NixOS host without putting it in the Nix store.
  #
  # XXX dhess - this is a hack and should be revisited.
  mkZncConfig = (import ../../modules/services/znc/conf.nix);


  # A list of all the NixOS test modules exported by this package.
  #
  # NOTE: do NOT use these in production. They will do bad
  # things, like writing secrets to your Nix store. Use them ONLY
  # for testing. You have been warned!
  testModulesList = ../../test-modules/module-list.nix;


  # All the NixOS test modules exported by this package.
  #
  # NOTE: do NOT use these in production. They will do bad
  # things, like writing secrets to your Nix store. Use them ONLY
  # for testing. You have been warned!
  testModules = import testModulesList;

in
{
  lib = (super.lib or {}) // {
    dhess-nix = (super.lib.dhess-nix or {}) // {
      inherit mkZncConfig;
      inherit modules modulesList;
      inherit path;

      testing = (super.lib.dhess-nix.testing or {}) // {      
        inherit testModules testModulesList;
      };
    };
  };
}
