#! /bin/bash
lazygit() {
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin
}
tmux() {
        DEBIAN_FRONTEND=noninteractive sudo apt-get install tmux -yq
}
zoxide() {
        DEBIAN_FRONTEND=noninteractive sudo apt-get install zoxide -y
}
stow() {
        DEBIAN_FRONTEND=noninteractive sudo apt-get install stow -y
}

packages() {
        DEBIAN_FRONTEND=noninteractive sudo apt-get upgrade -y
        lazygit
        stow
        tmux 
        zoxide 
}

tpm() {
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}
zap() {
        zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
}

package_managers(){
        tmp
        zap
}

symlinks() {
        DOTFILES_PATH=$(pwd)
        pushd ~
                cp $DOTFILES_PATH -R dotfiles
                rm .zshrc
        popd
        pushd ~/dotfiles
                stow .config
        popd
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
