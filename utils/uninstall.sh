#!/bin/zsh

#
# A shell script to automate the uninstall of the dotfiles.
#

# The parent directory of this script
DOTFILES="${0:a:h}"
INIT="$DOTFILES/lib/systemd/init"
[[ -r "$INIT" ]] && source "$INIT" || exit 1

#
# Uninstall
#

# Remove configurations
for file in "$HOME/editorconfig" "$HOME/.{hushlogin,zshenv}"; do
  [[ -f "$file" ]] && rm "$file"
done

for dir in "$XDG_CONFIG_HOME/{curl,git,nano,node,npm,ssh,tmux,zsh}" "$XDG_DATA_HOME/{nvm,zsh}"; do
  [[ -d "$dir" ]] && rm -rf "$dir"
  echo "configurations symlinks removed."
done

# Remove editorconfig symlink
if [ -L "${HOME}/.editorconfig" ]; then
  rm "${HOME}/.editorconfig"
  echo "editorconfig symlink removed."
else
  echo "No editorconfig symlink found in the home directory."
fi

# Uninstall Launch Agents and Unload .plist files
LAUNCHD_DIR="${LIB_DIR}/launchd"
LAUNCH_AGENTS="${HOME}/Library/LaunchAgents"
LAUNCH_DAEMONS="/Library/LaunchDaemons"

if [[ -d "$LAUNCHD_DIR" ]]; then
  if [[ -d "$LAUNCHD_DIR/updates" ]]; then
    launchctl unload "${LAUNCH_AGENTS}/com.shell.Updates.plist"
    rm "${LAUNCH_AGENTS}/com.shell.Updates.plist"
  fi

  if [[ -d "$LAUNCHD_DIR/launchpad" ]]; then
    sudo launchctl unload -w "${LAUNCH_DAEMONS}/com.shell.Launchpad.plist"
    sudo rm "${LAUNCH_DAEMONS}/com.shell.Launchpad.plist"
  fi
fi

# Unload and remove VSCode configs
CODE=/Applications/Visual\ Studio\ Code.app
CODE_USER="$HOME/Library/Application Support/Code/User"
if [[ -d "$CODE" ]]; then
  for config in "$CODE_USER"/{keybindings.json,settings.json}; do
    [[ -f "$config" ]] && rm "$config"
  done

  if [[ -d "$CODE_USER/configExtensions" ]]; then
    rm -rf "$CODE_USER/configExtensions"
  fi
fi

echo 'Dotfiles uninstalled!'
