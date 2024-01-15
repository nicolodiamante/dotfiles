#!/bin/sh

#
# Shell script to automate system tool setup for macOS.
#

# Uses the current script's directory, detect the OS, then loads…
DOTFILES="${${(%):-%x}:h}"
INIT="$DOTFILES/lib/systemd/init"
[[ "$OSTYPE" = darwin* && -r "$INIT" ]] && source "$INIT" || exit 1

#
# Install
#

# Check for Xcode command line tools, else install
echo 'Xcode: checking for command line tools...'
if xcode-select -p 1>/dev/null; then
  echo 'Xcode: command line tools installed!'
else
  echo 'Xcode: command line tools are missing! Installing it...'
  xcode-select --install
fi

# Check for Homebrew, else install
echo 'Checking for Homebrew...'
if [[ -z `command -v brew` ]]; then
  echo 'Brew is missing! Installing it...'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# XDG Base Directory Specification.
[[ ! -d "$XDG_CONFIG_HOME" ]] && mkdir -p "${XDG_CONFIG_HOME}"
[[ ! -d "$XDG_DATA_HOME" ]] && mkdir -p "${XDG_DATA_HOME}"
[[ ! -d "$XDG_STATE_HOME" ]] && mkdir -p "${XDG_STATE_HOME}"
[[ ! -d "$XDG_CACHE_HOME" ]] && mkdir -p "${XDG_CACHE_HOME}"

#
# Installing binaries and other packages
#

# Homebrew Bundle
echo 'Homebrew: installing binaries and other packages...'
brew update && brew bundle --file=${UTILS_DIR}/opt/homebrew/Brewfile && brew cleanup

#
# Symlinks to the local config files
#

echo 'Symlinking all configurations...'

# Curl
[[ ! -d "$XDG_CONFIG_HOME/curl" ]] && mkdir -p "${XDG_CONFIG_HOME}/curl"
ln -s "${LIB_DIR}/curl/curlrc" "${XDG_CONFIG_HOME}/curl/.curlrc"

# Nano
[[ ! -d "$XDG_CONFIG_HOME/nano" ]] && mkdir -p "${XDG_CONFIG_HOME}/nano"
ln -s "${LIB_DIR}/nano/nanorc" "${XDG_CONFIG_HOME}/nano"

# Zsh
if brew ls --versions zsh > /dev/null; then
  [[ ! -d "$XDG_STATE_HOME/zsh" ]] && mkdir -p "${XDG_STATE_HOME}/zsh"
  [[ ! -d "$XDG_CONFIG_HOME/zsh" ]] && mkdir -p "${XDG_CONFIG_HOME}/zsh"
  [[ ! -d "$XDG_CACHE_HOME/zsh" ]] && mkdir -p "${XDG_CACHE_HOME}/zsh"

  ln -s "${LIB_DIR}/zsh/zshenv" "${HOME}/.zshenv"
  ln -s "${LIB_DIR}/zsh/zlogin" "${XDG_CONFIG_HOME}/zsh/.zlogin"
  ln -s "${LIB_DIR}/zsh/zlogout" "${XDG_CONFIG_HOME}/zsh/.zlogout"
  ln -s "${LIB_DIR}/zsh/zprofile" "${XDG_CONFIG_HOME}/zsh/.zprofile"
  ln -s "${LIB_DIR}/zsh/zshrc" "${XDG_CONFIG_HOME}/zsh/.zshrc"
fi

# Git
if brew ls --versions git > /dev/null; then
  [[ ! -d "$XDG_CONFIG_HOME/git" ]] && mkdir -p "${XDG_CONFIG_HOME}/git"
  ln -s "${LIB_DIR}"/git/* "${XDG_CONFIG_HOME}/git"
fi

# Node
if brew ls --versions node > /dev/null; then
  # nvm
  if brew ls --versions nvm > /dev/null; then
    [[ ! -d "$XDG_CONFIG_HOME/nvm" ]] && mkdir -p "${XDG_CONFIG_HOME}/nvm"
  fi

  # Node
  [[ ! -d "$XDG_CONFIG_HOME/node" ]] && mkdir -p "${XDG_CONFIG_HOME}/node"
  [[ ! -d "$XDG_STATE_HOME/node" ]] && mkdir -p "${XDG_STATE_HOME}/node"
  [[ ! -d "$XDG_CONFIG_HOME/npm" ]] && mkdir -p "${XDG_CONFIG_HOME}/npm"
fi

# Tmux
if brew ls --versions tmux > /dev/null; then
  [[ ! -d "$XDG_CONFIG_HOME/tmux" ]] && mkdir -p "${XDG_CONFIG_HOME}/tmux"
  ln -s "${LIB_DIR}/tmux/lib/tmux.conf" "${XDG_CONFIG_HOME}/tmux/tmux.conf"
fi

# SSH
# See: https://bit.ly/2VK3nlm
# See: https://bit.ly/3lOMwIS
if [[ -d "$LIB_DIR/ssh" ]]; then
  [[ ! -d "$XDG_CONFIG_HOME/ssh" ]] && mkdir -p "${XDG_CONFIG_HOME}/ssh"
  [[ ! -d "$XDG_CONFIG_HOME/ssh" ]] && mkdir -p "${XDG_CONFIG_HOME}/ssh/keys"
  [[ ! -d "$XDG_DATA_HOME/ssh" ]] && mkdir -p "${XDG_DATA_HOME}/ssh"

  ln -s "${LIB_DIR}/ssh/config" "${XDG_CONFIG_HOME}/ssh/config"

  SSH_KEYS="${LIB_DIR}/ssh/keys"
  if [[ "$(ls -A $SSH_KEYS)" ]]; then
    ln -s "${SSH_KEYS}"/* "${HOME}/.config/ssh/keys"
  else
    echo "ln: ${LIB_DIR}/ssh/keys is empty!"
  fi

  # Known Hosts
  if [[ -e "${LIB_DIR}/ssh/known_hosts" ]]; then
    ln -s "${LIB_DIR}/ssh/known_hosts" "${XDG_DATA_HOME}/ssh"
  else
    touch "$LIB_DIR/ssh/know_hosts" && \
    ln -s "${LIB_DIR}/ssh/known_hosts" "${XDG_DATA_HOME}/ssh"
  fi

  # Correcting Permissions on the SSH Directory.
  # See: https://serverpilot.io/docs/how-to-use-ssh-public-key-authentication
  osascript -e '
  tell application "Terminal"
    set textToType1 to "chmod 700 ${XDG_CONFIG_HOME}/ssh"
    set textToType2 to "chmod 644 ${XDG_DATA_HOME}/ssh/known_hosts"

    tell application "System Events"
      keystroke textToType1
      delay 0.5
      keystroke return

      delay 0.5

      keystroke textToType2
      delay 0.5
      keystroke return
    end tell
  end tell'
fi

# Visual Studio Code
CODE=/Applications/Visual\ Studio\ Code.app
CODE_USER="${HOME}/Library/Application Support/Code/User"
CODE_CONFIG="${UTILS_DIR}/code"
CODE_EXTENSIONS="${UTILS_DIR}/opt/code/extensions"
if [[ -e "$CODE" ]]; then
  # Open the App to create the default directories.
  open "$CODE" && sleep 10 && osascript -e 'quit app "Visual Studio Code"'

  # User config
  for config in "${CODE_USER}"/{keybindings.json,settings.json}; do
    [[ -f "$config" ]] && rm -rf "${config}"
  done

  ln -s "${CODE_CONFIG}/keybindings.json" "${CODE_USER}"
  ln -s "${CODE_CONFIG}/settings.json" "${CODE_USER}"

  # Extensions
  [[ ! -d "${CODE_USER}/configExtensions" ]] && \
  mkdir -p "${CODE_USER}/configExtensions"

  ln -s "${CODE_CONFIG}/prettier/prettierrc" "${CODE_USER}/configExtensions"

  # Install Visual Studio Code Extensions.
  CODE=/Applications/Visual\ Studio\ Code.app
  if [[ -e "$CODE_EXTENSIONS" ]]; then
    source "${UTILS_DIR}/opt/code/extensions"
  fi
fi

# Xcode
XCODE=/Applications/Xcode.app
XCODE_THEMES="${HOME}/Library/Developer/Xcode/UserData/FontAndColorThemes"
if [[ -e "$XCODE" ]]; then
  # Open the App to create the default directories.
  open "$XCODE" && sleep 10 && osascript -e 'quit app "Xcode"'

  if [[ -d "$UTILS_DIR/opt/xcode" ]]; then
    if [[ ! -d "$XCODE_THEMES" ]]; then
      mkdir -p "${XCODE_THEMES}" && \
      ln -s "${UTILS_DIR}/opt/code/Copycat.xccolortheme" "${XCODE_THEMES}"
    else
      ln -s "${UTILS_DIR}/opt/code/Copycat.xccolortheme" "${XCODE_THEMES}"
    fi
  fi
fi

# Launch Agents
LAUNCHD_DIR="${LIB_DIR}/launchd"
LAUNCHD_LIB="${HOME}/Library/LaunchAgents"
if [[ -d "$LAUNCHD_DIR" ]]; then
  # Check for Launchpad plist, else create it.
  if [[ ! -d "$LAUNCHD_LIB" ]]; then
    mkdir -p "${LAUNCHD_LIB}"
  fi

  # Change directory to LAUNCHD_LIB
  cd "${LAUNCHD_LIB}" && \
  ln -s "${LAUNCHD_DIR}/updates/com.shell.Updates.plist" "${LAUNCHD_LIB}"

  # Load Launchpad plist
  osascript -e '
  tell application "Terminal"
    set textToType1 to "launchctl load com.shell.Updates.plist"

    tell application "System Events"
      keystroke textToType1
      delay 0.5
      keystroke return
    end tell
  end tell' && cd "${HOME}"
fi

# EditorConfig
EDITOR_CONFIG="${UTILS_DIR}/opt/editorconfig/editorconfig"
if [[ -d "$EDITOR_CONFIG" ]], then
  ln -s "${EDITOR_CONFIG}" "${HOME}/.editorconfig"
fi

# hushlogin
touch .hushlogin &&
cat << EOF >> "${HOME}/.hushlogin"
#
# The mere presence of this file in the home directory disables the
# system copyright notice, the date and time of the last login, the
# message of the day as well as other information that may otherwise
# appear on login. See 'man login'.
#
EOF

#
# Sets macOS
#

# Personal Settings
for packages (${UTILS_DIR}/opt/usr/*(N.)); do
  [[ -r "$packages" ]] && source "${packages}"
done

# Apple's System Fonts
# Ref: https://developer.apple.com/fonts/
APPLE_FONTS="${UTILS_DIR}/opt/macOS/fonts"
if [[ -e "$APPLE_FONTS" ]]; then
  source "${APPLE_FONTS}"
fi

# Ask before potentially overwriting files
read -q "REPLY?macOS: update your macOS System Default.
Before continuing, to make sure all changes will apply by going to:
System Preferences > Security & Privacy and grant Full Disk Access to Terminal.
Shall we proceed? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
 source "${UTILS_DIR}/opt/macOS/sysprefs"
else
  echo 'macOS: settings update skipped!'
fi

#
# Reboot macOS
#

read -q "REPLY?macOS: Done! Some of these changes require to reboot the system to take effect. Proceed? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
  osascript -e 'tell app "loginwindow" to «event aevtrrst»'
else
  echo 'macOS: reboot OS aborted!'
fi
