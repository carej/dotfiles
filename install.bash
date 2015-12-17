#!/bin/bash

GIT_REPO="git@bitbucket.org:durdn/cfg.git"
GIT_REPO_RO="https://bitbucket.org/durdn/cfg.git"
IGNORED="install.py|install.pyc|install.sh|.git$|.gitmodule|.gitignore|README|bin"

DEBUG=false
HOMEDIR=${HOME}/.homedir
BACKUP=${HOME}/.homebak

linkAsset() {

  if [[ ${DEBUG} == "true" ]]; then

    echo "ln -s ${HOMEDIR}/${1} ${HOME}/${1}"
  else

    ln -s ${HOMEDIR}/${1} ${HOME}/${1}
  fi
}

backupAsset() {

  if [[ ${DEBUG} == "true" ]]; then

    echo "mv ${HOME}/${1} ${BACKUP}/${1}"
  else

    mv ${HOME}/${1} ${BACKUP}/${1}
  fi
}

compare() {

  if [[ $(uname) == "Darwin" ]]; then

    [[ $(md5 -q ${1} | awk {'print $1'}) == $(md5 -q ${2} | awk {'print $1'}) ]]
  else

    [[ $(md5sum ${1} | awk {'print $1'}) == $(md5sum ${2} | awk {'print $1'}) ]]
  fi
}

link_assets() {

  for asset in "${@}"; do

    # asset does not exist, can just copy it
    #
    if [[ ! -e ${HOME}/${asset} ]]; then

      echo "N [new] ${HOME}/${asset}"
      linkAsset ${asset}

    # asset is an already existent directory
    #
    elif [[ -d ${HOME}/${asset} ]]; then

      if [[ -h ${HOME}/${asset} ]]; then

        echo "Id[ignore dir] ${HOME}/${asset}"
      else

        echo "Cd[conflict dir] ${HOME}/${asset}"
        backupAsset ${asset}
        linkAsset ${asset}
      fi

    # asset is exactly the same
    #
    elif compare ${HOME}/${asset} ${HOMEDIR}/${asset}; then

      # asset is exactly the same and is a link, all good
      #
      if [[ -h ${HOME}/${asset} ]]; then

        echo "I [ignore] ${HOME}/${asset}"

      # asset must be relinked
      #
      else

        echo "L [re-link] ${HOME}/${asset}"
        backupAsset ${asset}
        linkAsset ${asset}
      fi

    # asset exist but is different, must back it up
    #
    else

      echo "C [conflict] ${HOME}/${asset}"
      backupAsset ${asset}
      linkAsset ${asset}
    fi
  done
}

echo "|*    home : ${HOME}"
echo "|*  backup : ${BACKUP}"
echo "|* homedir : ${HOMEDIR}"

if [[ ! -e ${BACKUP} ]]; then

  mkdir -p ${BACKUP}
fi

# clone config folder if not present, update if present
#
if [[ ! -e ${HOMEDIR} ]]; then

  echo "|-> git clone from repo ${GIT_REPO}"
  git clone ${GIT_REPO} ${HOMEDIR}

  # clone the read-only repo if the initial clone failed
  #
  if [[ ! -e ${HOMEDIR} ]]; then

    echo "!!! ssh key not installed for this box, cloning read only repo"
    git clone ${GIT_REPO_RO} ${HOMEDIR}

    echo "|* changing remote origin to read/write repo: ${GIT_REPO}"
    cd ${HOMEDIR} && git config remote.origin.url ${GIT_REPO}
  fi
else

  echo "|-> homedir already cloned to ${HOMEDIR}"
  echo "|-> pulling origin master"
  # cd ${HOMEDIR} && git pull origin master
fi

ASSETS=$(ls -A1 ${HOMEDIR} | egrep -v ${IGNORED} | xargs)
echo "|* tracking assets: [ ${ASSETS} ] "
echo "|* linking assets in ${HOME}"
# link_assets