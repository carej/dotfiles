# .bash_profile

# get the aliases and functions
#
[[ -f ~/.bashrc ]] && . ~/.bashrc

# user specific environment and startup programs
#
export PATH=$PATH:$HOME/.local/bin:$HOME/bin

# rvm
#
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
