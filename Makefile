.PHONY: update switch switch-fix
all: u s

u: update
s: switch

update:
	nix flake update --verbose
	brew update

switch:
	sudo darwin-rebuild switch
	brew upgrade

fix:
	# sudo rm -f /etc/bashrc /etc/zshrc /etc/zshenv
	nix run nix-darwin -- switch --flake .#macbook
