#! /bin/bash
packages() {
        brew install lazygit stow tmux zoxide neovim starship
}

tpm() {
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

package_managers(){
        tpm
}

symlinks() {
	mv ~/.zshrc ~/.zshrc.bak
        stow configs
}

gitconfig() {
        git config --global rerere.enable true
        git config --global column.ui auto 
        git config --global branch.sort -commiterdate
}

install() {
        packages 
        symlinks
        gitconfig
        package_managers
}

install
