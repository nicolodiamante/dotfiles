#!/bin/zsh

#
# Shell script to automate system tool setup for macOS.
#

# Uses the current script's directory, detect the OS, then loads…
SCRIPT_DIR="${${(%):-%x}:h}"
INIT_SCRIPT="$SCRIPT_DIR/lib/systemd/init"
[[ "$OSTYPE" = darwin* && -r "$INIT_SCRIPT" ]] && source "$INIT_SCRIPT" || exit 1

#
# Install.
#

# Check for Xcode command line tools, else install.
echo 'Xcode: checking for command line tools...'
if xcode-select -p 1>/dev/null; then
  echo 'Xcode: command line tools installed!'
else
  echo 'Xcode: command line tools are missing! Installing it...'
  xcode-select --install
fi

# Check for Homebrew, else install.
echo 'Checking for Homebrew...'
if ! command -v brew >/dev/null 2>&1; then
  echo 'Brew is missing! Installing it...'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
    echo 'Brew installation failed. Exiting.'
    exit 1
  }
fi

# XDG Base Directory Specification.
CONFIG_HOME="${XDG_CONFIG_HOME}"
DATA_HOME="${XDG_DATA_HOME}"
STATE_HOME="${XDG_STATE_HOME}"
CACHE_HOME="${XDG_CACHE_HOME}"

[[ ! -d "$CONFIG_HOME" ]] && mkdir -p "$CONFIG_HOME"
[[ ! -d "$DATA_HOME" ]] && mkdir -p "$DATA_HOME"
[[ ! -d "$STATE_HOME" ]] && mkdir -p "$STATE_HOME"
[[ ! -d "$CACHE_HOME" ]] && mkdir -p "$CACHE_HOME"

# Homebrew Bundle.
echo 'Homebrew: installing binaries and other packages...'
brew update && brew bundle --file="${UTILS_DIR}/opt/homebrew/Brewfile" && brew cleanup

#
# Symlinks to the local config files.
#

echo 'Symlinking all configurations...'

# curl
if [[ ! -d "$XDG_CONFIG_HOME/curl" ]]; then
  mkdir -p "${XDG_CONFIG_HOME}/curl"
fi
ln -sf "${LIB_DIR}/curl/curlrc" "${XDG_CONFIG_HOME}/curl/.curlrc"

# nano
if [[ ! -d "$XDG_CONFIG_HOME/nano" ]]; then
  mkdir -p "${XDG_CONFIG_HOME}/nano"
fi
ln -sf "${LIB_DIR}/nano/nanorc" "${XDG_CONFIG_HOME}/nano"

# Zsh
if brew ls --versions zsh > /dev/null; then
  if [[ ! -d "$XDG_STATE_HOME/zsh" ]]; then
    mkdir -p "${XDG_STATE_HOME}/zsh"
  fi
  if [[ ! -d "$XDG_CONFIG_HOME/zsh" ]]; then
    mkdir -p "${XDG_CONFIG_HOME}/zsh"
  fi
  if [[ ! -d "$XDG_CACHE_HOME/zsh" ]]; then
    mkdir -p "${XDG_CACHE_HOME}/zsh"
  fi

  ln -sf "${LIB_DIR}/zsh/zshenv" "${HOME}/.zshenv"
  ln -sf "${LIB_DIR}/zsh/zlogin" "${XDG_CONFIG_HOME}/zsh/.zlogin"
  ln -sf "${LIB_DIR}/zsh/zlogout" "${XDG_CONFIG_HOME}/zsh/.zlogout"
  ln -sf "${LIB_DIR}/zsh/zprofile" "${XDG_CONFIG_HOME}/zsh/.zprofile"
  ln -sf "${LIB_DIR}/zsh/zshrc" "${XDG_CONFIG_HOME}/zsh/.zshrc"
fi

# Git
if brew ls --versions git > /dev/null; then
  if [[ ! -d "$XDG_CONFIG_HOME/git" ]]; then
    mkdir -p "${XDG_CONFIG_HOME}/git"
  fi

  ln -sf "${LIB_DIR}/git/"* "${XDG_CONFIG_HOME}/git"
fi

# Install npm packages.
if brew ls --versions node > /dev/null; then
  # Nodejs.
  if [[ ! -d "$XDG_CONFIG_HOME/node" ]]; then
    mkdir -p "${XDG_CONFIG_HOME}/node"
   if [[ ! -d "$XDG_STATE_HOME/node" ]]; then
    mkdir -p "${XDG_STATE_HOME}/node"
  fi
  if [[ ! -d "$XDG_CONFIG_HOME/npm" ]]; then
    mkdir -p "${XDG_CONFIG_HOME}/npm"
  fi
fi

# Tmux
if brew ls --versions tmux > /dev/null; then
  if [[ ! -d "$XDG_STATE_HOME/tmux" ]]; then
    mkdir -p "${XDG_STATE_HOME}/tmux"
  fi
  if [[ ! -d "$XDG_CONFIG_HOME/tmux/plugins" ]]; then
    mkdir -p "${XDG_CONFIG_HOME}/tmux/plugins"
  fi

  ln -sf "${LIB_DIR}/tmux/lib/tmux.conf" "${XDG_CONFIG_HOME}/tmux/tmux.conf"
fi

# SSH
# See: https://bit.ly/2VK3nlm
# See: https://bit.ly/3lOMwIS
if [[ -d "$LIB_DIR/ssh" ]]; then
  if [[ -d "$HOME/.ssh" ]]; then
    PS3="rm: remove SSH directory already exist in '${HOME}/.ssh'? "
    opts=("rm" "mv" "exit")
    select opt in "${opts[@]}"; do
      case $opt in
        "rm")
            rm -rf "${HOME}/.ssh" && break
            ;;
        "mv")
            [[ ! -d "$XDG_CONFIG_HOME/ssh" ]] && mkdir -p "${XDG_CONFIG_HOME}/ssh"
            [[ ! -d "$XDG_CONFIG_HOME/ssh/keys" ]] && mkdir -p "${XDG_CONFIG_HOME}/ssh/keys"
            [[ ! -d "$XDG_DATA_HOME/ssh" ]] && mkdir -p "${XDG_DATA_HOME}/ssh"

            mv -nv "${HOME}/.ssh/config" "${XDG_CONFIG_HOME}/ssh"
            mv -nv "${HOME}/.ssh/known_hosts" "${XDG_DATA_HOME}/ssh"
            break
            ;;
        "exit") break ;;
        *) echo "invalid option $REPLY" ;;
      esac
    done
  fi

  [[ ! -d "$XDG_CONFIG_HOME/ssh" ]] && mkdir -p "${XDG_CONFIG_HOME}/ssh" && \
                                       mkdir -p "${XDG_CONFIG_HOME}/ssh/keys"
  ln -sf "${LIB_DIR}/ssh/config" "${XDG_CONFIG_HOME}/ssh"

  SSH_KEYS="${LIB_DIR}/ssh/keys"
  if [ "$(ls -A "$SSH_KEYS")" ]; then
    ln -sf "${SSH_KEYS}"/* "${HOME}/.config/ssh/keys"
  else
    echo "ln: ${LIB_DIR}/ssh/keys is empty!"
  fi

  # Correcting Permissions on the SSH Directory.
  # See: https://serverpilot.io/docs/how-to-use-ssh-public-key-authentication
  chmod 700 "${XDG_CONFIG_HOME}/ssh"

  [[ ! -d "$XDG_DATA_HOME/ssh" ]] && mkdir -p "${XDG_DATA_HOME}/ssh"
  if [[ -e "${LIB_DIR}/ssh/known_hosts" ]]; then
    ln -sf "${LIB_DIR}/ssh/known_hosts" "${XDG_DATA_HOME}/ssh"
  else
    touch "$LIB_DIR/ssh/know_hosts" && \
    ln -sf "${LIB_DIR}/ssh/known_hosts" "${XDG_DATA_HOME}/ssh"

    chmod 644 "${XDG_DATA_HOME}/ssh/known_hosts"
  fi
fi

# Visual Studio Code
CODE="/Applications/Visual Studio Code.app"
CODE_USER="${HOME}/Library/Application Support/Code/User"
CODE_CONFIG="${UTILS_DIR}/code"
CODE_EXTENSIONS="${UTILS_DIR}/opt/code/extensions"

if [[ -e "$CODE" ]]; then
  # Open the App to create the default directories.
  open "$CODE" && sleep 10 && osascript -e 'quit app "Visual Studio Code"'

  # User config
  for config in "${CODE_USER}"/{keybindings.json,settings.json}; do
    if [[ -f "$config" ]]; then
      rm -f "${config}"
    fi
  done

  ln -sf "${CODE_CONFIG}/keybindings.json" "${CODE_USER}"
  ln -sf "${CODE_CONFIG}/settings.json" "${CODE_USER}"

  # Extensions
  if [[ ! -d "${CODE_USER}/configExtensions" ]]; then
    mkdir -p "${CODE_USER}/configExtensions"
  fi

  ln -sf "${CODE_CONFIG}/prettier/prettierrc" "${CODE_USER}/configExtensions"

  # Install Visual Studio Code Extensions.
  if [[ -e "$CODE_EXTENSIONS" ]]; then
    source "${UTILS_DIR}/opt/code/extensions"
  fi
fi

# Launch Agents
# Ref: https://apple.co/2LhI2ub
LAUNCHD_DIR="${LIB_DIR}/launchd"
LAUNCHD_LIB="${HOME}/Library/LaunchAgents"

if [[ -d "$LAUNCHD_DIR" ]]; then
  if [[ ! -d "$LAUNCHD_LIB" ]]; then
    mkdir -p "${LAUNCHD_LIB}"
  fi

  if [[ -d "$LAUNCHD_DIR/launchpad" ]]; then
    ln -sf "${LAUNCHD_DIR}/launchpad/com.shell.Launchpad.plist" "${LAUNCHD_LIB}"
  fi

  if [[ -d "$LAUNCHD_DIR/updates" ]]; then
    ln -sf "${LAUNCHD_DIR}/updates/com.shell.Updates.plist" "${LAUNCHD_LIB}"
  fi

  cd "${HOME}/Library/LaunchAgents"

  osascript -e '
  tell application "Terminal"

    set textToTypeOne to "launchctl load com.shell.Launchpad.plist"
    set textToTypeTwo to "launchctl load com.shell.Updates.plist"

    tell application "System Events"
      keystroke textToTypeOne & return & delay 0.5
      keystroke textToTypeTwo & return & delay 0.5
    end tell
  end tell'

  cd "${HOME}"
fi

# User Credentials
if [[ ! -d "${USER_DIR}" ]]; then
  mkdir -p "user" && cd "$_"

  # Create the user configuration file.
  user_config_file="${USER_DIR}/config"
  touch "${user_config_file}"

  # Add the content to the user configuration file.
cat << EOF > "${user_config_file}"
#
# System-wide user shell configurations. This file will be sourced
# along with the other files. You can use it to add commands you
# do not want to commit to a public repository.
#

if (( $+commands[git] )); then
  # Prevent people from accidentally committing my credentials.
  GIT_USER=$(git config user.name)
  GIT_EMAIL=$(git config user.email)
  GIT_KEY=$(git config user.signingkey)
  GIT_EDITOR=$(git config core.editor)
  GIT_BRANCH=$(git config init.defaultBranch)

  if [[ -z "$GIT_USER" || -z "$GIT_EMAIL" || -z "$GIT_EDITOR" || -z "$GIT_BRANCH" || -z "$GIT_KEY" ]]; then
    # Your Git credential.
    GIT_AUTH_NAME=""
    GIT_AUTH_EMAIL=""
    GIT_AUTH_KEY=""
    GIT_CORE_EDITOR=""
    GIT_DEFAULT_BRANCH=""

    [[ -n "$GIT_AUTH_NAME" ]] && git config --global user.name "${GIT_AUTH_NAME}"
    [[ -n "$GIT_AUTH_EMAIL" ]] && git config --global user.email "${GIT_AUTH_EMAIL}"
    [[ -n "$GIT_AUTH_KEY" ]] && git config --global user.signingkey "${GIT_AUTH_KEY}"
    [[ -n "$GIT_CORE_EDITOR" ]] && git config --global core.editor "${GIT_CORE_EDITOR}"
    [[ -n "$GIT_DEFAULT_BRANCH" ]] && git config --global init.defaultBranch "${GIT_DEFAULT_BRANCH}"
  fi

  # Git
  alias g="git"
fi
EOF
fi

# Link the "editorconfig" file to home directory if it exists
if [ -f "${UTILS_DIR}/opt/editorconfig/editorconfig" ]; then
    ln -sf "${UTILS_DIR}/opt/editorconfig/editorconfig" "${HOME}/.editorconfig"
else
    echo "Unable to find the source file: ${UTILS_DIR}/opt/editorconfig/editorconfig"
fi

# hushlogin
hushlogin_file="${HOME}/.hushlogin"
cat << EOF > "${hushlogin_file}"
#
# The mere presence of this file in the home directory disables the
# system copyright notice, the date and time of the last login, the
# message of the day as well as other information that may otherwise
# appear on login. See 'man login'.
#
EOF

# Apple Devs.
for packages in "${UTILS_DIR}/opt/apple/"*; do
  if [[ -r "${packages}" ]]; then
    source "${packages}"
  fi
done

#
# Sets macOS.
#

# Ask before potentially overwriting files.
read -q "REPLY?macOS: update your macOS System Default.
Before continuing, to ensure all changes apply, head to System Preferences > Security & Privacy, then grant Full Disk Access to Terminal. Ready to proceed? (y/n) "
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
  source "${UTILS_DIR}/opt/macOS/sysprefs"
else
  echo 'macOS: settings update skipped!'
fi

#
# Reboot OS.
#

read -q "REPLY?macOS: Done! Some of these changes require a reboot to take effect. Proceed with reboot? (y/n) "
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
  osascript -e 'tell app "loginwindow" to «event aevtrrst»'
else
  echo 'macOS: Reboot aborted.'
fi
