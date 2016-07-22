# .bashrc

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
sip /etc/bash.bashrc
sip /usr/share/bash-completion/bash_completion
sip /usr/share/bash-completion/completions/git
sip ~/.bash_aliases
sip ~/.bash_functions
unset sip

# source all of the files in the users .bash_completion.d directory
#
#for COMPLETION in $(find -L ~/.bash_completion.d -type f); do
#
#  source "${COMPLETION}"
#done
#unset COMPLETION

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
[[ -d /usr/local/gradle ]] && {

  export GRADLE_HOME=/usr/local/gradle
  export PATH=${GRADLE_HOME}/bin:${PATH}
}

# setup nodejs
#
NODE_DIR="/cygdrive/c/Program Files/nodejs"
if [[ -d "${NODE_DIR}" ]]; then

  export PATH="${NODE_DIR}":${PATH}

  NPM_G="$(cygpath $(npm bin -g))"
  if [[ -d "${NPM_G}" ]]; then

    export PATH="${NPM_G}":${PATH}
  fi
  unset NPM_G
fi
unset NODE_DIR

# setup JDK
#
export JAVA_HOME="/c/Program Files/Java/jdk1.8.0_74"
export PATH="${JAVA_HOME}/bin:${PATH}"
