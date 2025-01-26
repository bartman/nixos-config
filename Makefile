PWD = $(shell pwd)

all: nixos-rebuild-switch

nixos-rebuild-switch:
	sudo nixos-rebuild switch --flake "${PWD}#"
