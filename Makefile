PWD  = $(shell pwd)
USER ?= $(shell id -u -n)
HOST ?= $(shell hostname)

#IMPURE = --impure
#TRACE  = --show-trace

# detect if we are on a NixOS, or just using home-manager
FOUND_NIXOS_REBUILD = $(shell which nixos-rebuild 2>/dev/null)

# 'nh' provides nicer status/progress output as it's building
# see:  https://github.com/viperML/nh
# use it if available...
FOUND_NH            = $(shell nh --help 2>/dev/null | grep 'Yet another nix helper')

COMMAND ?= $(if ${FOUND_NIXOS_REBUILD},nixos-rebuild,home-manager)

ACTIONS = build switch test $(if ${FOUND_NIXOS_REBUILD},boot,instantiate)
ACTION  ?= switch

NIXOS_REBUILD_ACTIONS = $(foreach n,${ACTIONS},nixos-rebuild/$n)
HOME_MANAGER_ACTIONS = $(foreach n,${ACTIONS},home-manager/$n)

RUN = $(if ${DRYRUN},@echo,)

DEFAULT_RULE = ${COMMAND}/${ACTION}
all: ${DEFAULT_RULE}

${ACTIONS}: %:
	${MAKE} -s ACTION=$@

nixos-rebuild/init:
	${Q}echo "You're on NixOS"

${NIXOS_REBUILD_ACTIONS}: nixos-rebuild/%:
	$(if ${FOUND_NIXOS_REBUILD},,$(error could not find nixos-rebuild command))
ifeq (${FOUND_NH},)
	${RUN} sudo nixos-rebuild $(notdir $@) ${IMPURE} ${TRACE} --flake "${PWD}#" ${EXTRA}
else
	${RUN} nh os $(notdir $@) .
endif

home-manager/init:
	${RUN} nix run home-manager -- init

${HOME_MANAGER_ACTIONS}: home-manager/%:
ifeq (${FOUND_NH},)
	${RUN} nix run home-manager -- $(subst test,instantiate,$(notdir $@)) ${IMPURE} ${TRACE} -b backup --flake "${PWD}/#${USER}@${HOST}" ${EXTRA}
else
	${RUN} nh home $(notdir $@) .
endif

