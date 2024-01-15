#!/bin/zsh

#
# A shell script to automate the uninstall of the dotfiles.
#

# Source the initialization script to set up the environment
INIT_SCRIPT="${0:a:h}/lib/systemd/init"
if [[ -r "$INIT_SCRIPT" ]]; then
  source "${INIT_SCRIPT}"
else
  echo "Error: Initialization script ${INIT_SCRIPT} not found to set up the environment." >&2
  exit 1
fi

# Confirmation prompt
read -q "REPLY?This will uninstall the dotfiles and remove related configurations. Are you sure you want to proceed? [y/N] "
echo ""
if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
  echo "Uninstallation aborted by the user."
  exit 0
fi

#
# Uninstall
#

echo "Start removing Dotfiles..."

# Remove configurations
for file in "$HOME/editorconfig" "$HOME/.{hushlogin,zshenv}"; do
  [[ -f "$file" ]] && rm "$file"
done

for dir in "$XDG_CONFIG_HOME/{curl,git,nano,node,npm,tmux,zsh}" "$XDG_DATA_HOME/{nvm,zsh}"; do
  [[ -d "$dir" ]] && rm -rf "$dir"
  echo "configurations symlinks removed."
done

# Remove editorconfig symlink
if [[ -L "${HOME}/.editorconfig" ]]; then
  rm "${HOME}/.editorconfig"
  echo "editorconfig symlink removed."
else
  echo "No editorconfig symlink found in the home directory."
fi

# Uninstall Launch Agents and unload plist files
LAUNCHD_DIR="${LIB_DIR}/launchd"
LAUNCHD_LIB="${HOME}/Library/LaunchAgents"
if [[ -d "$LAUNCHD_DIR" ]]; then
  # Change director and load Launchpad plist
  cd "${LAUNCHD_LIB}" && osascript -e '
  tell application "Terminal"
    set textToType1 to "launchctl unload com.shell.Updates.plist"

    tell application "System Events"
      keystroke textToType1
      delay 0.5
      keystroke return
    end tell
  end tell'

  # Remove Launchpad plist
  rm "${LAUNCHD_LIB}/com.shell.Updates.plist" && cd "${HOME}"
fi

# Unload and remove Visual Studio Code configs
CODE="/Applications/Visual\ Studio\ Code.app"
CODE_USER="$HOME/Library/Application Support/Code/User"
if [[ -d "$CODE" ]]; then
  for config in "$CODE_USER"/{keybindings.json,settings.json}; do
    [[ -f "$config" ]] && rm "$config"
  done

  if [[ -d "$CODE_USER/configExtensions" ]]; then
    rm -rf "$CODE_USER/configExtensions"
  fi
fi

echo "Dotfiles uninstalled successfully!"
