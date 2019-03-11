self: super:

let

  # A list of "core" Python packages that I want to build for any
  # given release of this overlay.
  coreList = pp: with pp; [
    flake8
    importmagic
    ipython
    jedi
    yapf
  ];  

  python-env = super.python.buildEnv.override {
    ignoreCollisions = true;
    extraLibs = coreList super.pythonPackages;
  };

in
{
  inherit python-env;
}
