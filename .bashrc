# .bashrc

# prevent default group writes & disallow ANY permissions to others
#
umask 027

# source global definitions
#
[[ -f /etc/bashrc ]] && . /etc/bashrc

# source local aliases
#
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

# source local functions
#
[[ -f ~/.bash_functions ]] && . ~/.bash_functions

# uncomment the following line if you don't like systemctl's auto-paging feature:
#
# export SYSTEMD_PAGER=

# set a custom prompt
#
export PS1="\n\e[0;32m[\t]\e[m \e[0;34m\w\e[m \e[0;31m\$(parse_git_branch)\e[m\n\u@\h (\!) \\$ "

# map git aliases to bash aliases (shamelessly stolen from https://gist.github.com/mwhite/6887990)
#
if function_exists '__git_aliases'; then

  for al in $(__git_aliases); do

    alias g${al}="git ${al}"

    complete_func=_git_$(__git_aliased_command ${al})
    function_exists ${complete_fnc} && __git_complete g${al} ${complete_func}
  done
fi
