#!/bin/sh

#
# A shell script to automate the uninstall of the dotfiles.
#

# Uses the current script's directory then loads…
DOTFILES="${${(%):-%x}:h}"
INIT="$DOTFILES/lib/systemd/init"
[[ -r "$INIT" ]] && source "$INIT" || exit 1

#
# Uninstall
#

# Remove related configurations.
for file in ${$HOME}/.{hushlogin,zshenv}; do
  if [[ -f "$file" ]]; then
    rm "${file}"
  fi
done

for dir in ${XDG_CONFIG_HOME}/{curl,git,nano,node,npm,ssh,zsh}; do
  if [[ -d "$dir" ]]; then
    rm -rf "${dir}"
  fi
done

for dir in ${XDG_DATA_HOME}/{nvm,zsh}; do
  if [[ -d "$dir" ]]; then
    rm -rf "${dir}"
  fi
done

# Launch Agents
LAUNCHD_LIB=${HOME}/Library/LaunchAgents
if [ -z "$(ls -A "$LAUNCHD_LIB" | head -n 5)" ]; then
  cd ${HOME}/Library/LaunchAgents && osascript -e '
  tell application "Terminal"

    set textToTypeOne to "launchctl unload com.shell.Launchpad.plist"
    set textToTypeTwo to "launchctl unload com.shell.Updates.plist"

    tell application "System Events"
      (* Load the first job. *)
      keystroke textToTypeOne

      (* Wait a little bit to ensure that the job is loaded. *)
      delay 0.5

      keystroke return

      (* Load the second job. *)
      keystroke textToTypeTwo

      (* Wait a little bit to ensure that the job is loaded. *)
      delay 0.5

      keystroke return
    end tell
  end tell' && cd "${$HOME}"

  if [[ -f "$LAUNCHD_LIB/com.shell.Launchpad.plist" ]]; then
    rm "${LAUNCHD_LIB}/com.shell.Launchpad.plist"
  fi

  if [[ -f "$LAUNCHD_LIB/com.shell.Updates.plist" ]]; then
    rm "${LAUNCHD_LIB}/com.shell.Updates.plist"
  fi
fi

# Visual Studio Code
CODE=/Applications/Visual\ Studio\ Code.app
CODE_USER=${HOME}/Library/Application\ Support/Code/User
CODE_CONFIG=${PREFS_DIR}/code/config
if [[ -e "$CODE" ]]; then
  # User config
  for config in ${CODE_USER}/{keybindings.json,settings.json}; do
    [[ -r "$config" ]] && rm -rf "${config}"
  done

  # Extensions
  if [[ -d "${CODE_USER}/configExtensions" ]]; then
    rm -rf "${CODE_USER}/configExtensions"
  fi
fi

echo 'Dotfiles uninstalled!'
