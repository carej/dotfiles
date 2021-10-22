# .bashrc

# make MacOS shut up about zsh being the default (Bash forever)
#
export BASH_SILENCE_DEPRECATION_WARNING=1

# prevent default group writes & disallow ANY permissions to others
#
umask 022

# source (a file) if present
#
# $1 - the file to source
#
function sip() {

  [[ -f "${1}" ]] && source "${1}"
}

# source a bunch of crap and then kill the sip function
#
sip /etc/bashrc
sip ~/.bash_aliases
sip ~/.bash_functions
unset sip

# source all of the files in the users .bash_completion.d directory
#
for COMPLETION in $(find -L ~/.bash_completion.d -type f); do

  source "${COMPLETION}"
done
unset COMPLETION

# set a custom prompt
#
export PS1="\n\e[0;32m[\t]\e[m \e[0;34m\w\e[m \e[0;31m\$(parse_git_branch)\e[m\n\u@\h (\!) \\$ "

# map git aliases to bash aliases (shamelessly stolen from https://gist.github.com/mwhite/6887990)
#
for al in $(git --list-cmds=alias); do

  alias g${al}="git ${al}"

  complete_func=_git_$(__git_aliased_command ${al} | tr - _)
  function_exists ${complete_fnc} && __git_complete g${al} ${complete_func}
done
unset al

# set nano as the editor if it's available
#
if command -v nano >/dev/null 2>&1; then

  export EDITOR=nano
  alias pico='nano'
fi
