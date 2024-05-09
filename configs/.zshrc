plug "jeffreytse/zsh-vi-mode"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(tmuxifier init -)"

export EDITOR=nvim
export VISUAL=nvim
