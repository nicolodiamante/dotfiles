#!/bin/zsh

#
# A shell script to automate the uninstall of the dotfiles.
#

# Source the initialization script to set up the environment.
# Uses the current script's directory, detect the OS, then loads…
# Define the script directories.
if [[ "$0" = /* ]]; then
  ROOT_DIR=$(dirname "$0")
else
  ROOT_DIR=$(dirname "$PWD/$0")
fi
INIT_SCRIPT="${ROOT_DIR}/lib/systemd/init"

if [[ -r "$INIT_SCRIPT" ]]; then
  source "${INIT_SCRIPT}"
else
  echo "Dotfiles: Initialization script ${INIT_SCRIPT} not found to set up the environment." >&2
  exit 1
fi

# Confirmation prompt.
read -q "REPLY?This will uninstall the dotfiles and remove related configurations. Are you sure you want to proceed? [y/N] "
echo ""
if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
  echo "Dotfiles: Uninstall aborted by the user."
  exit 0
fi

#
# Uninstall
#

echo "\nDotfiles: Start removing Dotfiles..."

# Remove Configurations.
echo "\nDotfiles: Removing configurations for editorconfig, hushlogin, and zshenv at ${HOME}"
for file in "$HOME/.{editorconfig,hushlogin,zshenv}"; do
  if [[ -f "$file" ]]; then
    rm "${file}" && echo "Removed file: ${file}"
  else
    echo "File not found, skipping: ${file}"
  fi
done

echo "\nDotfiles: Removing configurations for curl, git, nano, node, npm, tmux, and zsh at ${XDG_CONFIG_HOME}"
for dir in "$XDG_CONFIG_HOME/{curl,git,nano,node,npm,tmux,zsh}" "$XDG_DATA_HOME/{nvm,zsh}"; do
  if [[ -d "$dir" ]]; then
    rm -rf "${dir}" && echo "Removed symlink configurations for: ${dir}"
  else
    echo "Directory not found, skipping: ${dir}"
  fi
done

# Unload and remove Visual Studio Code configs.
CODE="/Applications/Visual Studio Code.app"
CODE_USER="${HOME}/Library/Application Support/Code/User"

if [[ -d "$CODE" ]]; then
  echo "\nDotfiles: Removing Visual Studio Code configurations..."
  for config in "$CODE_USER"/{keybindings.json,settings.json}; do
    if [[ -f "$config" ]]; then
      rm "${config}" && echo "Removed Visual Studio Code config: ${config}"
    else
      echo "Visual Studio Code config not found, skipping: ${config}"
    fi
  done

  if [[ -d "$CODE_USER/configExtensions" ]]; then
    rm -rf "${CODE_USER}/configExtensions" && echo "Removed Visual Studio Code extension configs."
  fi
  echo "Dotfiles: Visual Studio Code configurations removed."
fi

# Prints a success message.
echo "\nmacOS: Dotfiles uninstall complete."
