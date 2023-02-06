eval "$(starship init bash)"
eval "$(fnm env --use-on-cd)"
. $HOME/bin/z.sh
alias vim="nvim"
alias vi="nvim"
alias cat="bat"
alias pn="pnpm"

export PATH=$HOME/bin:$PATH
export EDITOR="nvim"
export GITHUB_TOKEN="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"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
