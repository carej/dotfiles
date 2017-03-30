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

# check that a function exists (shamelessly stolen from https://gist.github.com/mwhite/6887990)
#
function function_exists() {

  declare -f -F ${1} > /dev/null
  return ${?}
}

# list or less
#
function l() {

  # handle special (common?) case for no arguments
  #
  if (( ${#} == 0 )); then

    ll
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

  (( ${#dirs[@]} > 0 )) && ll "${dirs[@]}"

  (( ${#files[@]} > 0 )) && less "${files[@]}"
}

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
  git checkout ${1}
  git reset --hard @{upstream}
  git rebase --interactive origin/${2}
}
