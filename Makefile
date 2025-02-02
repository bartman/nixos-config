PWD  = $(shell pwd)
USER = $(shell id -u -n)
HOST = $(shell hostname)

#IMPURE = --impure
#TRACE  = --show-trace

FOUND_NIXOS_REBUILD = $(shell which nixos-rebuild 2>/dev/null)

ACTIONS = build test switch

NIXOS_REBUILD_ACTIONS = $(foreach n,${ACTIONS},nixos-rebuild/$n)
HOME_MANAGER_ACTIONS = $(foreach n,${ACTIONS},home-manager/$n)

DEFAULT_RULE = $(if ${FOUND_NIXOS_REBUILD},nixos-rebuild/switch,home-manager/switch)

all: ${DEFAULT_RULE}

${NIXOS_REBUILD_ACTIONS}: nixos-rebuild/%:
	$(if ${FOUND_NIXOS_REBUILD},,$(error could not find nixos-rebuild command))
	sudo nixos-rebuild $(notdir $@) ${IMPURE} ${TRACE} --flake "${PWD}#"

${HOME_MANAGER_ACTIONS}: home-manager/%:
	nix run home-manager -- $(notdir $@) ${IMPURE} ${TRACE} --flake "${PWD}/#${USER}@${HOST}"
