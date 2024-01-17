#!/bin/zsh

#
# Updates Homebrew and its installed packages.
#

# Resolve HOmebrew root macOS Sonoma or later
SW_VERS=$(sw_vers --productVersion)
OS_VERS=$(echo "$SW_VERS" | cut -d '.' -f 1)

if [[ "$OS_VERS" -ge 14 ]]; then
  brew=/opt/homebrew/bin/brew
else
  brew=/usr/local/Homebrew/bin/brew
fi

# Homebrew Update
if [[ -x $brew ]]; then
  $brew update 2>&1
  $brew upgrade 2>&1
  $brew upgrade --cask 2>&1
  $brew cleanup 2>&1
fi
