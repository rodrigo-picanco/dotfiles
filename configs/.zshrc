eval "$(zoxide init zsh)"

export EDITOR=nvim
export VISUAL=nvim

. /opt/homebrew/opt/asdf/libexec/asdf.sh

export PATH="$HOME/.asdf/shims:$HOME/.asdf/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"
eval "$(direnv hook zsh)"
