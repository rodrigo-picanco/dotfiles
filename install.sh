#! /bin/bash


packages() {
        brew install neovim tmux tmuxifier lazygit starship zoxide zsh-vi-mode -y
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
}


brew() {
        test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
        test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc
}

symlinks() {
        current_dir="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
        dotfiles_source="${current_dir}/configs"

        while read -r file; do

                relative_file_path="${file#"${dotfiles_source}"/}"
                target_file="${HOME}/${relative_file_path}"
                target_dir="${target_file%/*}"

                if test ! -d "${target_dir}"; then
                        mkdir -p "${target_dir}"
                fi

                printf 'Installing dotfiles symlink %s\n' "${target_file}"
                ln -sf "${file}" "${target_file}"

        done < <(find "${dotfiles_source}" -type f)
}

install() {
        brew
        packages 
        symlinks
}

install
