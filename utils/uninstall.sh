#!/bin/zsh

#
# A shell script to automate the uninstall of the dotfiles.
#

# Source the initialization script to set up the environment.
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

# Remove configurations.
for file in "$HOME/editorconfig" "$HOME/.{hushlogin,zshenv}"; do
  [[ -f "$file" ]] && rm "$file"
done

for dir in "$XDG_CONFIG_HOME/{curl,git,nano,node,npm,ssh,tmux,zsh}" "$XDG_DATA_HOME/{nvm,zsh}"; do
  [[ -d "$dir" ]] && rm -rf "$dir"
  echo "configurations symlinks removed."
done

# Remove editorconfig symlink.
if [ -L "${HOME}/.editorconfig" ]; then
  rm "${HOME}/.editorconfig"
  echo "editorconfig symlink removed."
else
  echo "No editorconfig symlink found in the home directory."
fi

# Uninstall Launch Agents and Unload .plist files.
LAUNCHD_DIR="${LIB_DIR}/launchd"
LAUNCH_AGENTS="${HOME}/Library/LaunchAgents"
LAUNCH_DAEMONS="/Library/LaunchDaemons"

if [[ -d "$LAUNCHD_DIR" ]]; then
  if [[ -d "$LAUNCHD_DIR/norflow" ]]; then
    launchctl unload "${LAUNCH_AGENTS}/com.shell.Norflow.plist"
    rm "${LAUNCH_AGENTS}/com.shell.Norflow.plist"
  fi

  if [[ -d "$LAUNCHD_DIR/prune" ]]; then
    launchctl unload "${LAUNCH_AGENTS}/com.shell.Prune.plist"
    rm "${LAUNCH_AGENTS}/com.shell.Prune.plist"
  fi

  if [[ -d "$LAUNCHD_DIR/updates" ]]; then
    launchctl unload "${LAUNCH_AGENTS}/com.shell.Updates.plist"
    rm "${LAUNCH_AGENTS}/com.shell.Updates.plist"
  fi
fi

# Unload and remove VSCode configs.
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
