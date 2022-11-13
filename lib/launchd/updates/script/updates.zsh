#!/bin/zsh

#
# Updates Homebrew and its installed packages.
#

brew=/usr/local/Homebrew/bin/brew

# Homebrew
if [[ -x $brew ]]; then
  $brew update 2>&1
  $brew upgrade 2>&1
  $brew upgrade --cask 2>&1
  $brew cleanup 2>&1
fi
