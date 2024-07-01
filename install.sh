#! /bin/bash
lazygit() {
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin
}

packages() {
        lazygit
        DEBIAN_FRONTEND=noninteractive sudo apt-get install stow tmux zoxide -yq
}

tpm() {
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

package_managers(){
        tpm
}

symlinks() {
        if [ ! -d ~/dotfiles ]; then
                cp $(pwd) -R ~/dotfiles
        fi

        cd ~/dotfiles
        stow configs
}

gitconfig() {
        git config --global rerere.enable true
        git config --global column.ui auto 
        git config --global branch.sort -committerdate
}

install() {
        packages 
        symlinks
        gitconfig
        package_managers
}

install
