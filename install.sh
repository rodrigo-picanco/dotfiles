#! /bin/bash
lazygit() {
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin
}
tpm() {
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}
zap() {
        zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
}
tmux() {
        sudo apt-get install tmux -y
}
zoxide() {
        sudo apt-get install zoxide -y
}
stow() {
        sudo apt-get install stow -y
}

packages() {
        lazygit
        stow
        tmux 
        tpm
        zap
        zoxide 
}

symlinks() {
        dotfiles_cd=$(pwd)
        pushd ~
                cp  dotifles_cd -R dotfiles
        popd
        pushd ~/dotfiles
                stow .config
        popd
}

install() {
        packages 
        symlinks
}

install
