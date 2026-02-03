# Dotfiles

My macOS dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Installation

On a fresh macOS machine:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/rodrigo-picanco/dotfiles/main/install.sh)"
```

Or if you've already cloned the repo:

```bash
cd ~/.local/share/chezmoi
./install.sh
```

## What's Included

- **Window Manager:** AeroSpace
- **Automation:** Hammerspoon  
- **Terminal:** Ghostty, Tmux
- **Editor:** Neovim with LSP
- **Shell:** Zsh with Oh-My-Zsh
- **Dev Tools:** lazygit, lazydocker, docker, colima, k9s
- **CLI Tools:** fzf, ripgrep, zoxide, gh, opencode
- **Version Manager:** ASDF

## Management

```bash
# Update dotfiles from remote
chezmoi update

# Edit a config file
chezmoi edit ~/.config/nvim/init.lua

# Apply local changes
chezmoi apply

# Check status
chezmoi status
```
