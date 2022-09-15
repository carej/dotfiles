# .bash_aliases

alias ll='ls -lhG'
alias la='ls -lhGA'
alias dirs='command dirs -v'

# special completion stuff for kubectl being aliased to k
#
alias k='kubectl'
complete -F __start_kubectl k
