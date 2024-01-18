#!/bin/zsh

#
# A shell script to automate the uninstall of the dotfiles.
#

# Source the initialization script to set up the environment.
# Uses the current script's directory, detect the OS, then loads…
# Define the script directories
if [[ "$0" = /* ]]; then
  ROOT_DIR=$(dirname "$0")
else
  ROOT_DIR=$(dirname "$PWD/$0")
fi
INIT_SCRIPT="${ROOT_DIR}/lib/systemd/init"

if [[ -r "$INIT_SCRIPT" ]]; then
  source "${INIT_SCRIPT}"
else
  echo "Error: Initialization script ${INIT_SCRIPT} not found to set up the environment." >&2
  exit 1
fi

# Confirmation prompt.
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

# Remove Configurations.
for file in "$HOME/.{editorconfig,hushlogin,zshenv}"; do
  [[ -f "$file" ]] && rm "${file}" && echo "Removed file: ${file}"
done

for dir in "$XDG_CONFIG_HOME/{curl,git,nano,node,npm,tmux,zsh}" "$XDG_DATA_HOME/{nvm,zsh}"; do
  [[ -d "$dir" ]] && rm -rf "${dir}" && echo "Removed symlink configurations for: ${dir}"
done

# Uninstall Launch Agent.
LAUNCHD_LIB="${HOME}/Library/LaunchAgents"
AGENT_TARGET="${LAUNCHD_LIB}/updates/com.shell.Updates.plist"
AGENTS_DIR="${HOME}/.scripts"
AGENT_SCRIPT="${AGENTS_DIR}/updates.zsh"

# Unload the agent.
if [[ -f "$AGENT_TARGET" ]]; then
  echo "Unloading the agent..."
  if ! launchctl unload "${AGENT_TARGET}"; then
    echo "Failed to unload the agent." >&2
  else
    echo "Agent unloaded successfully."
    # Remove the symlink
    rm "${AGENT_TARGET}"
  fi
else
  echo "Agent not found or already unloaded."
fi

# Remove the script.
if [[ -f "$AGENT_SCRIPT" ]]; then
  rm "${AGENT_SCRIPT}"
  echo "Agent script removed."
else
  echo "Agent script not found or already removed."
fi

# Unload and remove Visual Studio Code configs.
CODE="/Applications/Visual Studio\ Code.app"
CODE_USER="${HOME}/Library/Application Support/Code/User"

if [[ -d "$CODE" ]]; then
  for config in "$CODE_USER"/{keybindings.json,settings.json}; do
    if [[ -f "$config" ]]; then
      rm "${config}" && echo "Removed Visual Studio Code config: ${config}"
    else
      echo "Visual Studio Code config not found: ${config}"
    fi
  done

  if [[ -d "$CODE_USER/configExtensions" ]]; then
    rm -rf "${CODE_USER}/configExtensions" && echo "Removed Visual Studio Code extension configs."
  fi
fi

echo "Dotfiles uninstalled successfully!"
