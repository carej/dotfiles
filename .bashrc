# .bashrc

# prevent default group writes & disallow ANY permissions to others
#
umask 027

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
for COMPLETION in $(find ~/.bash_completion.d -type f); do

  source "${COMPLETION}"
done
unset COMPLETION

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
  unset al
fi

# set nano as the editor if it's available
#
if command -v nano >/dev/null 2>&1; then

  export EDITOR=nano
  alias pico='nano'
fi

# setup gradle
#
export GRADLE_HOME=/usr/local/gradle
export PATH=${GRADLE_HOME}/bin:${PATH}
