# .bash_profile

# get the aliases and functions
#
[[ -f ~/.bashrc ]] && . ~/.bashrc

# user specific environment and startup programs
#
export PATH=$PATH:$HOME/.local/bin:$HOME/bin

# set nano as the editor if it's available
#
if command -v nano >/dev/null 2>&1; then

  export EDITOR=nano
  alias pico='nano'
fi

# setup Chef if it's available
#
command -v chef >/dev/null 2>&1 && eval "$(chef shell-init bash)"
