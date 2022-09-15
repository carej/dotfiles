# .bash_profile

# enable Homebrew to work properly
#
eval "$(/opt/homebrew/bin/brew shellenv)"

# user specific environment and startup programs
#
export PATH=${HOME}/.local/bin:${HOME}/bin:${PATH}

# get the aliases and functions
#
[[ -f ~/.bashrc ]] && . ~/.bashrc

