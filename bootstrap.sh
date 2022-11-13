#!/bin/sh

#
# Install dotfiles
#

# Detects the Operating System.
[[ "$OSTYPE" = darwin* ]] || exit 1

# Resolve dotfiles root (from OS X 10.12 Sierra or later).
OSVERS=$(sw_vers -buildVersion)
if [[ "$OSVERS" > 16 ]]; then
  CLOUD_DOCS="${HOME}/Library/Mobile Documents/com~apple~CloudDocs"
fi

DOTFILES_ROOT="${ZDOTDIR:-${CLOUD_DOCS:-$HOME}}/dotfiles"
INSTALL=./utils/install.sh

SOURCE=https://github.com/nicolodiamante/dotfiles
TARBALL="${SOURCE}/tarball/master"
TARGET="${DOTFILES_ROOT}"
TAR_CMD="tar -xzv -C "${TARGET}" --strip-components 1 --exclude .gitignore"

is_executable() {
  type "$1" > /dev/null 2>&1
}

# Checks if already installed otherwise installs.
if [[ -d "$DOTFILES_ROOT" ]]; then
  read -q "REPLY?dotfiles already exist in ${DOTFILES_ROOT}. Proceed with the installation? (y/n) " -n 1;
  echo "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    source "${INSTALL}"
  fi
else
  # Checks which executable is available then downloads and installs.
  if is_executable "git"; then
    CMD="git clone ${SOURCE} ${TARGET}"
  elif is_executable "curl"; then
    CMD="curl -L ${TARBALL} | ${TAR_CMD}"
  elif is_executable "wget"; then
    CMD="wget --no-check-certificate -O - ${TARBALL} | ${TAR_CMD}"
  fi

  if [[ -z "$CMD" ]]; then
    echo 'No git, curl or wget available. Aborting!'
  else
    echo 'Installing dotfiles...'
    mkdir -p "${TARGET}" && eval "${CMD}" && cd "${TARGET}" && source "${INSTALL}"
  fi
fi
