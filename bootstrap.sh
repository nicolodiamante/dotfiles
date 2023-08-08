#!/bin/zsh

#
# Install dotfiles
#

# Exit if not MacOS
[[ "$OSTYPE" = darwin* ]] || exit 1

# Identify Operating System
MACOS_BUILD=$(sw_vers -buildVersion)
MACOS_VERSION=$(sed -E -e 's/([0-9]{2}).*/\1/' <<< "$MACOS_BUILD")
if [[ "$MACOS_VERSION" -ge 16 ]]; then
  CLOUD_DOCS="${HOME}/Library/Mobile Documents/com~apple~CloudDocs"
fi

DOTFILES_ROOT="${ZDOTDIR:-${CLOUD_DOCS:-$HOME}}/dotfiles"
INSTALL=./utils/install.sh

SOURCE=https://github.com/nicolodiamante/dotfiles
TARBALL="${SOURCE}/tarball/master"
TARGET="${DOTFILES_ROOT}"
TAR_CMD="tar -xzv -C "${TARGET}" --strip-components 1 --exclude .gitignore"

# Check if command is executable
is_executable() {
  type "$1" > /dev/null 2>&1
}

# Check if dotfiles already installed and proceed based on user input
if [[ -d "$DOTFILES_ROOT" ]]; then
  read -q "REPLY?dotfiles already exist in ${DOTFILES_ROOT}. Proceed with the installation? (y/n) " -n 1;
  echo "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    source "${INSTALL}"
  fi
else
  # Check which download method is available
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
