# .bash_profile

# get the aliases and functions
#
[[ -f ~/.bashrc ]] && . ~/.bashrc

# user specific environment and startup programs
#
export PATH=${HOME}/.local/bin:${HOME}/bin:${PATH}

# enable Homebrew to work properly
#
eval "$(/opt/homebrew/bin/brew shellenv)"
