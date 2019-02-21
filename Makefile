# NOTE:
#
# This Makefile is very much tailored to the maintainer's environment.
# It might work for you, but don't expect much.

all:
	nix build -f jobsets/release.nix --keep-going

linux:
	nix build -f jobsets/release.nix --keep-going --arg supportedSystems '[ "x86_64-linux" ]' x86_64-linux

linux-nixpkgs:
	nix build -f jobsets/release.nix -I nixpkgs_override=../nixpkgs --keep-going --arg supportedSystems '[ "x86_64-linux" ]' x86_64-linux

darwin:
	nix build -f jobsets/release.nix --keep-going --arg supportedSystems '[ "x86_64-darwin" ]' x86_64-darwin

darwin-nixpkgs:
	nix build -f jobsets/release.nix -I nixpkgs_override=../nixpkgs --keep-going --arg supportedSystems '[ "x86_64-darwin" ]' x86_64-darwin

help:
	@echo "Targets:"
	@echo
	@echo "(Default is 'all')"
	@echo
	@echo "    all       	     - build all release packages for all platforms"
	@echo "    darwin-nixpkgs    - build all release packages for x86_64-darwin against the local nixpkgs"
	@echo "    linux-nixpkgs     - build all release packages for x86_64-linux against the local nixpkgs"
	@echo
	@echo "    help      - show this message"
