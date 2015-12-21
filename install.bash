#!/bin/bash -eu

GIT_REPO="ssh://git@sensus-stash.davis.sensus.lab:7999/~carej/dotfiles.git"
GIT_REPO_RO="http://carej@sensus-stash.davis.sensus.lab:7990/scm/~carej/dotfiles.git"
IGNORED="install.bash|localtest.bash|.git$|.git/|.gitignore|README|README.md"

DEBUG=false
DOTFILES=${HOME}/.dotfiles
BACKUP=${HOME}/.backup

linkAsset() {

  if [[ ${DEBUG} == "true" ]]; then

    echo "ln -s ${DOTFILES}/${1} ${HOME}/${1}"
  else

    ln -s "${DOTFILES}/${1}" "${HOME}/${1}"
  fi
}

backupAsset() {

  local bf="${BACKUP}/${1}"

  if [[ ${DEBUG} == "true" ]]; then

    echo "mkdir -p '${bf%/*}'"
    echo "mv ${HOME}/${1} ${bf}"
  else

    mkdir -p "${bf%/*}"
    mv "${HOME}/${1}" "${bf}"
  fi
}

compare() {

  [[ $(md5sum "${1}" | awk {'print $1'}) == $(md5sum "${2}" | awk {'print $1'}) ]]
}

mkdir -p ${BACKUP}

# clone config folder if not present, update if present
#
if [[ ! -e ${DOTFILES} ]]; then

  echo "|-> git clone from repo ${GIT_REPO}"
  git clone ${GIT_REPO} ${DOTFILES}

  # clone the read-only repo if the initial clone failed
  #
  if [[ ! -e ${DOTFILES} ]]; then

    echo "!!! ssh key not installed for this box, cloning read only repo"
    git clone ${GIT_REPO_RO} ${DOTFILES}

    echo "|* changing remote origin to read/write repo: ${GIT_REPO}"
    cd ${DOTFILES} && git config remote.origin.url ${GIT_REPO}
  fi
else

  echo "|-> homedir already cloned to ${DOTFILES}"
  echo "|-> pulling origin master"
  # cd ${DOTFILES} && git pull origin master
fi

echo "|* linking assets in ${HOME}"
find ${DOTFILES} -type f -printf '%P\n' | egrep -v ${IGNORED} | while read asset; do

  # asset does not exist, can just copy it
  #
  if [[ ! -e "${HOME}/${asset}" ]]; then

    echo "N [new]          ${HOME}/${asset}"
    linkAsset "${asset}"

  # asset is an already existent directory
  #
  elif [[ -d "${HOME}/${asset}" ]]; then

    if [[ -h "${HOME}/${asset}" ]]; then

      echo "Id[ignore dir]   ${HOME}/${asset}"
    else

      echo "Cd[conflict dir] ${HOME}/${asset}"
      backupAsset "${asset}"
      linkAsset "${asset}"
    fi

  # asset is exactly the same
  #
  elif compare "${HOME}/${asset}" "${DOTFILES}/${asset}"; then

    # asset is exactly the same and is a link, all good
    #
    if [[ -h "${HOME}/${asset}" ]]; then

      echo "I [ignore]       ${HOME}/${asset}"

    # asset must be relinked
    #
    else

      echo "L [re-link]      ${HOME}/${asset}"
      backupAsset "${asset}"
      linkAsset "${asset}"
    fi

  # asset exist but is different, must back it up
  #
  else

    echo "C [conflict]     ${HOME}/${asset}"
    backupAsset "${asset}"
    linkAsset "${asset}"
  fi
done
