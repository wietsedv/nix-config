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

# terra
terra-sync:
	rsync --delete --filter=":- .gitignore" -avh ./ terra:/etc/nixos

terra: terra-sync
	ssh -t terra nixos-rebuild switch --sudo

terra-test: terra-sync
	ssh -t terra nixos-rebuild test --sudo

# mars
mars-sync:
	rsync --delete --filter=":- .gitignore" -avh ./ mars:/etc/nixos

mars: mars-sync
	ssh -t mars sudo nixos-rebuild switch  --sudo

mars-test: mars-sync
	ssh -t mars sudo nixos-rebuild test --sudo

# luna
luna-sync:
	rsync --delete --filter=":- .gitignore" -avh ./ luna:/etc/nixos

luna: luna-sync
	ssh -t luna nixos-rebuild switch --sudo

luna-test: luna-sync
	ssh -t luna nixos-rebuild test --sudo
