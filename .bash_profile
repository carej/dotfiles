# .bash_profile

# Get the aliases and functions
#
if [[ -f ~/.bashrc ]]; then

  . ~/.bashrc
fi

# User specific environment and startup programs
#
export PATH=$PATH:$HOME/.local/bin:$HOME/bin
export EDITOR=nano
export PS1="\n\e[0;32m[\t]\e[m \e[0;34m\u@\h\e[m\n\w \$ "

# Chef (if available)
#
if command -v chef > /dev/null; then

  eval "$(chef shell-init bash)"
fi
