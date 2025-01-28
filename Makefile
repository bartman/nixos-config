PWD  = $(shell pwd)
USER = $(shell id -u -n)

FOUND_NIXOS_REBUILD = $(shell which nixos-rebuild 2>/dev/null)

DEFAULT_RULE = $(if ${FOUND_NIXOS_REBUILD},nixos-rebuild-switch,home-manager-switch)

all: ${DEFAULT_RULE}

nixos-rebuild-switch:
	$(if ${FOUND_NIXOS_REBUILD},,$(error could not find nixos-rebuild command))
	sudo nixos-rebuild switch --flake "${PWD}#"

home-manager-switch:
	nix run home-manager -- switch --impure --show-trace --flake "${PWD}/${USER}"
