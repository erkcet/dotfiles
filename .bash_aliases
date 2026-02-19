
alias codex='codex --dangerously-bypass-approvals-and-sandbox'

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ls variants
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'

# safer rm/mv/cp
alias rm='rm -I'
alias mv='mv -i'
alias cp='cp -i'

# git
alias gs='git status -sb'
alias gl='git log --oneline --decorate --graph -n 20'
alias gd='git diff'
alias gds='git diff --staged'
alias gp='git push'
alias gpl='git pull --ff-only'
alias gco='git checkout'
alias gcb='git checkout -b'

# tools
alias rg='rg --smart-case'
alias df='df -h'
alias du='du -h'

# create + cd
mkcd() { mkdir -p "$1" && cd "$1"; }
