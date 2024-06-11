SHELL=/bin/zsh

DOTFILES_DIR=~/dotfiles
SRC_DIR=$(DOTFILES_DIR)/src

.PHONY: dev
dev: dev-apply debian

.PHONY: dev-apply
dev-apply:
	rm -rf $(DOTFILES_DIR)
	cp -r . $(DOTFILES_DIR)

.PHONY: install-eza
install-eza:
	sudo mkdir -p /etc/apt/keyrings
	wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
	echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
	sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
	sudo apt update
	sudo apt -y install eza=0.18.10

.PHONY: install-debian
install-debian: install-eza
	sudo apt update
	sudo apt -y install bat bfs fd-find fzf ripgrep thefuck zoxide

.PHONY: starship
starship:
	curl -sS https://starship.rs/install.sh | sh -s -- -y

.PHONY: symlink
symlink:
	rm -rf ~/.zshrc ~/.zimrc ~/.zim
	ln -s $(SRC_DIR)/.zshrc ~/.zshrc
	ln -s $(SRC_DIR)/.zimrc ~/.zimrc

	rm -rf ~/.gitconfig
	ln -s $(SRC_DIR)/.gitconfig ~/.gitconfig

	mkdir -p ~/.config && rm -rf ~/.config/starship.toml
	ln -s $(SRC_DIR)/.config/starship.toml ~/.config/starship.toml

.PHONY: symlink-mac
symlink-mac:
	rm -rf ~/.Brewfile
	ln -s $(SRC_DIR)/.Brewfile ~/.Brewfile

.PHONY: mac
mac: starship symlink symlink-mac
	source ~/.zshrc

.PHONY: debian
debian: install-debian starship symlink
	source ~/.zshrc
