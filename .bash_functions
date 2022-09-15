# .bash_functions

# get current branch in git repo (shamelessly stolen from ezprompt.net)
#
function parse_git_branch() {

  # don't show the git decoration in the home directory; this is important
  # because I usually manage the configuration files in my home via a git repo
  # and it's usually going to be out of date
  #
  if [[ "${PWD}" == "${HOME}" ]]; then

    echo ""
    return
  fi

  local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [[ "${branch}" != "" ]]; then

    echo "[${branch}$(parse_git_dirty)]"
  else

    echo ""
  fi
}
export -f parse_git_branch

# get current status of git repo (shamelessly stolen from ezprompt.net)
#
function parse_git_dirty() {

  local status=$(git status 2>&1)
  local bits=''

  echo -n "${status}" 2>/dev/null | grep "renamed:"                &>/dev/null && bits=">${bits}"
  echo -n "${status}" 2>/dev/null | grep "Your branch is ahead of" &>/dev/null && bits="*${bits}"
  echo -n "${status}" 2>/dev/null | grep "new file:"               &>/dev/null && bits="+${bits}"
  echo -n "${status}" 2>/dev/null | grep "Untracked files"         &>/dev/null && bits="?${bits}"
  echo -n "${status}" 2>/dev/null | grep "deleted:"                &>/dev/null && bits="x${bits}"
  echo -n "${status}" 2>/dev/null | grep "modified:"               &>/dev/null && bits="!${bits}"

  if [[ "${bits}" != "" ]]; then

    echo " ${bits}"
  else

    echo ""
  fi
}
export -f parse_git_dirty

# check that a function exists (shamelessly stolen from https://gist.github.com/mwhite/6887990)
#
function function_exists() {

  declare -f -F ${1} > /dev/null
  return ${?}
}
export -f function_exists

# list or less
#
function l() {

  # handle special (common?) case for no arguments
  #
  if (( ${#} == 0 )); then

    ls -lhG
    return
  fi

  local -a files
  local -a dirs

  local arg
  for arg in "${@}"; do

    if [[ -d "${arg}" ]]; then

      dirs+=("${arg}")
    else

      files+=("${arg}")
    fi
  done

  (( ${#dirs[@]} > 0 )) && ls -lhG "${dirs[@]}"

  (( ${#files[@]} > 0 )) && less "${files[@]}"
}
export -f l

# convenience wrapper around "git worktree add"
#
function gwta() {

  local arg
  for arg in "${@}"; do

    git worktree add -b ${arg} ../${arg} origin/${arg}
  done
}

# convenience wrapper around "git worktree add" for creating a new working tree
# from the current HEAD
#
function gwtc() {

  local arg
  for arg in "${@}"; do

    git push origin HEAD:${arg}
    gwta ${arg}
  done
}

# convenience wrapper for performing interactive rebases
#
function gqrb() {

  git fetch origin --prune
  git checkout ${2}
  git reset --hard @{upstream}
  git rebase --interactive origin/${1}
}

# $1 - the file to expand
# $2 - the expansion destination
# $3 - recurse
#
function inflate {

  echo "inflating ${1}"

  case ${1} in

    *.zip|*.jar|*.war|*.ear)
      unzip -qq ${1} -d ${2}
      ;;

    *.tar|*.tgz|*.tar.gz)
      tar -C ${2} xf ${1}
      ;;
  esac

  if [[ ${3} ]]; then

    for FILE in $(find ${2} -type f \( -name '*.zip' -o -name '*.jar' -o -name '*.war' -o -name '*.ear' -o -name '*.tar' -o -name '*.tgz' -o -name '*.tar.gz' \)); do

      inflate ${FILE} $(dirname ${FILE})/expanded-$(basename ${FILE})
    done
  fi
}
export -f inflate

function expandArchive() {

  RECURSIVE=false

  until [[ ${#} -eq 0 ]]; do
    case ${1} in

      -R|--recursive)
        RECURSIVE=true
        shift
        ;;

      *)
        break
        ;;
    esac
  done

  for FILE in "${@}"; do

    # skip things that are not files
    #
    [[ ! -f ${FILE} ]] && continue

    EXPANDED=$(dirname ${FILE})/expanded-$(basename ${FILE})
    [[ -d ${EXPANDED} ]] && continue

    mkdir ${EXPANDED}
    inflate ${FILE} ${EXPANDED} ${RECURSIVE}
  done
}
export -f expandArchive
