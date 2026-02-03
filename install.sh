#!/usr/bin/env bash

################################################################################
# macOS Dotfiles Bootstrap Script
# 
# This script will:
# - Install Homebrew (if needed)
# - Install chezmoi and apply dotfiles
# - Install all required CLI tools and GUI applications
# - Set up Oh-My-Zsh, Tmux Plugin Manager, and ASDF
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/rodrigo-picanco/dotfiles/main/install.sh | bash
#   
# Or locally:
#   ./install.sh
################################################################################

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Output functions
info() {
    echo -e "${BLUE}==>${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

error() {
    echo -e "${RED}✗ Error:${NC} $1" >&2
}

warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

section() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC} $1"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

################################################################################
# Prerequisite Checks
################################################################################

section "Checking Prerequisites"

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    error "This script is for macOS only"
    exit 1
fi
success "Running on macOS"

# Check if running as root (we don't want that)
if [[ $EUID -eq 0 ]]; then
    error "This script should not be run as root"
    exit 1
fi
success "Not running as root"

################################################################################
# Homebrew Installation
################################################################################

section "Setting up Homebrew"

if ! command -v brew &> /dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    success "Homebrew installed"
else
    success "Homebrew already installed"
fi

# Verify brew is in PATH
if ! command -v brew &> /dev/null; then
    error "Homebrew installation failed or not in PATH"
    exit 1
fi

################################################################################
# Xcode Command Line Tools
################################################################################

section "Installing Xcode Command Line Tools"

if ! xcode-select -p &> /dev/null; then
    info "Installing Xcode Command Line Tools..."
    xcode-select --install
    
    # Wait for installation to complete
    info "Waiting for Xcode Command Line Tools installation to complete..."
    info "(You may need to accept the license in the GUI)"
    until xcode-select -p &> /dev/null; do
        sleep 5
    done
    success "Xcode Command Line Tools installed"
else
    success "Xcode Command Line Tools already installed"
fi

################################################################################
# Chezmoi & Dotfiles
################################################################################

section "Setting up Chezmoi and Dotfiles"

# Install chezmoi if not present
if ! command -v chezmoi &> /dev/null; then
    info "Installing chezmoi..."
    brew install chezmoi
    success "chezmoi installed"
else
    success "chezmoi already installed"
fi

# Determine if we're running from within the dotfiles repo or need to init
if [[ -d "$HOME/.local/share/chezmoi/.git" ]]; then
    info "Dotfiles repo already initialized, applying..."
    chezmoi apply
    success "Dotfiles applied"
else
    info "Initializing dotfiles from GitHub..."
    chezmoi init --apply rodrigo-picanco
    success "Dotfiles initialized and applied"
fi

################################################################################
# Homebrew Packages
################################################################################

section "Installing Homebrew Packages"

info "Updating Homebrew..."
brew update

info "Upgrading existing packages..."
brew upgrade || true  # Don't fail if nothing to upgrade

# CLI Tools
CLI_TOOLS=(
    zoxide
    ripgrep
    neovim
    fzf
    lazygit
    lazydocker
    docker
    docker-compose
    colima
    k9s
    tmux
    gh
    opencode
)

info "Installing CLI tools..."
for tool in "${CLI_TOOLS[@]}"; do
    if brew list "$tool" &> /dev/null; then
        success "$tool already installed"
    else
        info "Installing $tool..."
        brew install "$tool"
        success "$tool installed"
    fi
done

# GUI Applications (Casks)
CASKS=(
    ghostty
    raycast
    aerospace
    hammerspoon
)

info "Installing GUI applications..."
for cask in "${CASKS[@]}"; do
    if brew list --cask "$cask" &> /dev/null; then
        success "$cask already installed"
    else
        info "Installing $cask..."
        brew install --cask "$cask"
        success "$cask installed"
    fi
done

info "Cleaning up Homebrew..."
brew cleanup
success "Homebrew cleanup complete"

################################################################################
# Oh-My-Zsh
################################################################################

section "Setting up Oh-My-Zsh"

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    info "Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    success "Oh-My-Zsh installed"
else
    success "Oh-My-Zsh already installed"
fi

################################################################################
# Tmux Plugin Manager
################################################################################

section "Setting up Tmux Plugin Manager (TPM)"

TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
    info "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    success "TPM installed"
else
    success "TPM already installed"
fi

################################################################################
# ASDF Version Manager
################################################################################

section "Setting up ASDF Version Manager"

ASDF_DIR="$HOME/.asdf"
if [[ ! -d "$ASDF_DIR" ]]; then
    info "Installing ASDF version manager..."
    git clone https://github.com/asdf-vm/asdf.git "$ASDF_DIR"
    cd "$ASDF_DIR"
    git checkout "$(git describe --abbrev=0 --tags)" 2>/dev/null || git checkout master
    success "ASDF installed"
else
    success "ASDF already installed"
fi

################################################################################
# Completion Summary
################################################################################

section "Installation Complete! 🎉"

cat << 'EOF'
📦 Installed:
  • Homebrew & Xcode Command Line Tools
  • Chezmoi + dotfiles
  • CLI Tools: zoxide, ripgrep, neovim, fzf, lazygit, lazydocker,
              docker, docker-compose, colima, k9s, tmux, gh, opencode
  • GUI Apps: Ghostty, Raycast, AeroSpace, Hammerspoon
  • Oh-My-Zsh, TPM, ASDF

📝 Next:
  • Create ~/.zshrc.local for private config (if needed)
  • Reload shell: exec zsh

📁 Locations:
  • Dotfiles: ~/.local/share/chezmoi
  • Configs: ~/.config

EOF

success "All done! Run 'exec zsh' to reload your shell."
