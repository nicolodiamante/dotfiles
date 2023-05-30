#!/bin/sh

#
# Shell script to automate system tool setup for macOS.
#

# Uses the current script's directory, detect the OS, then loads…
DOTFILES="${${(%):-%x}:h}"
INIT="$DOTFILES/lib/systemd/init"
[[ "$OSTYPE" = darwin* && -r "$INIT" ]] && source "$INIT" || exit 1

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
if [[ -z `command -v brew` ]]; then
  echo 'Brew is missing! Installing it...'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# XDG Base Directory Specification.
[[ ! -d "$XDG_CONFIG_HOME" ]] && mkdir -p "${XDG_CONFIG_HOME}"
[[ ! -d "$XDG_DATA_HOME" ]] && mkdir -p "${XDG_DATA_HOME}"
[[ ! -d "$XDG_STATE_HOME" ]] && mkdir -p "${XDG_STATE_HOME}"
[[ ! -d "$XDG_CACHE_HOME" ]] && mkdir -p "${XDG_CACHE_HOME}"

# Homebrew Bundle.
echo 'Homebrew: installing binaries and other packages...'
brew update && brew bundle --file=${UTILS_DIR}/opt/homebrew/Brewfile && brew cleanup

#
# Symlinks to the local config files.
#

echo 'Symlinking all configurations...'

# curlrc
[[ ! -d "$XDG_CONFIG_HOME/curl" ]] && mkdir -p "${XDG_CONFIG_HOME}/curl"
ln -s "${LIB_DIR}/curl/curlrc" "${XDG_CONFIG_HOME}/curl/.curlrc"

# nanorc
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

# Install npm packages.
if brew ls --versions node > /dev/null; then
  # nvm
  if brew ls --versions nvm > /dev/null; then
    [[ ! -d "$XDG_CONFIG_HOME/nvm" ]] && mkdir -p "${XDG_CONFIG_HOME}/nvm"
  fi

  # Nodejs.
  [[ ! -d "$XDG_CONFIG_HOME/node" ]] && mkdir -p "${XDG_CONFIG_HOME}/node"
  [[ ! -d "$XDG_STATE_HOME/node" ]] && mkdir -p "${XDG_STATE_HOME}/node"
  [[ ! -d "$XDG_CONFIG_HOME/npm" ]] && mkdir -p "${XDG_CONFIG_HOME}/npm"

  if [[ -d "$LIB_DIR/npm" ]]; then
    ln -s "${LIB_DIR}/npm/lib/npmrc" "${XDG_CONFIG_HOME}/npm"
  fi

  # Start a new terminal session
  # otherwise it will install the packages into `~/.npm` directory.
  exec zsh -l && source "${UTILS_DIR}/opt/npm/packages"
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
            rm -r "${HOME}/.ssh" && break
            ;;
        "mv")
            [[ ! -d "$XDG_CONFIG_HOME/ssh" ]] && mkdir -p "${XDG_CONFIG_HOME}/ssh"
            [[ ! -d "$XDG_CONFIG_HOME/ssh/ssh/keys" ]] && mkdir -p "${XDG_CONFIG_HOME}/ssh/keys"
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
  ln -s "${LIB_DIR}/ssh/config" "${XDG_CONFIG_HOME}/ssh"

  SSH_KEYS="${LIB_DIR}/ssh/keys"
  if [ "$(ls -A $SSH_KEYS)" ]; then
    ln -s "${SSH_KEYS}"/* "${HOME}/.config/ssh/keys"
  else
    echo "ln: ${LIB_DIR}/ssh/keys is empty!"
  fi

  # Correcting Permissions on the SSH Directory.
  # Ensure that your account home directory, your ssh directory and file
  # authorized_keys are not group-writable or world-writable. Recommended
  # permissions for .ssh directory are 700. Recommended permissions for
  # authorized_keys files are 600. This file must be readable and writable
  # only by the user, and not accessible by others.
  # See: https://serverpilot.io/docs/how-to-use-ssh-public-key-authentication
  osascript -e '
  tell application "Terminal"

    set textToType to "chmod 700 ${XDG_CONFIG_HOME}/ssh"

    tell application "System Events"
      (* Load the first job. *)
      keystroke textToType

      (* Wait a little bit to ensure that the job is loaded. *)
      delay 0.5

      keystroke return
    end tell
  end tell'

  [[ ! -d "$XDG_DATA_HOME/ssh" ]] && mkdir -p "${XDG_DATA_HOME}/ssh"
  if [[ -e "${LIB_DIR}/ssh/known_hosts" ]]; then
    ln -s "${LIB_DIR}/ssh/known_hosts" "${XDG_DATA_HOME}/ssh"
  else
    touch "$LIB_DIR/ssh/know_hosts" && \
    ln -s "${LIB_DIR}/ssh/known_hosts" "${XDG_DATA_HOME}/ssh" &&

      osascript -e '
      tell application "Terminal"

        set textToType to "chmod 644 ${XDG_DATA_HOME}/ssh/known_hosts"

        tell application "System Events"
          (* Load the first job. *)
          keystroke textToType

          (* Wait a little bit to ensure that the job is loaded. *)
          delay 0.5

          keystroke return
        end tell
      end tell'
  fi
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

  ln -s "${CODE_CONFIG}/csscomb/csscomb.json" "${CODE_USER}/configExtensions"
  ln -s "${CODE_CONFIG}/prettier/prettierrc" "${CODE_USER}/configExtensions"

  # Install Visual Studio Code Extensions.
  CODE=/Applications/Visual\ Studio\ Code.app
  if [[ -e "$CODE_EXTENSIONS" ]]; then
    source "${UTILS_DIR}/opt/code/extensions"
  fi
fi

# Launch Agents
# Ref: https://apple.co/2LhI2ub
LAUNCHD_DIR="${LIB_DIR}/launchd"
LAUNCHD_LIB="${HOME}/Library/LaunchAgents"
if [[ -d "$LAUNCHD_DIR" ]]; then
  [[ ! -d "$LAUNCHD_LIB" ]] && mkdir -p "${LAUNCHD_LIB}" &&

  [[ -d "$LAUNCHD_DIR/launchpad" ]] &&
  ln -s "${LAUNCHD_DIR}/launchpad/com.shell.Launchpad.plist" "${LAUNCHD_LIB}"

  [[ -d "$LAUNCHD_DIR/updates" ]] &&
  ln -s "${LAUNCHD_DIR}/updates/com.shell.Updates.plist" "${LAUNCHD_LIB}"

  cd "${HOME}/Library/LaunchAgents" && osascript -e '
  tell application "Terminal"

    set textToTypeOne to "launchctl load com.shell.Launchpad.plist"
    set textToTypeTwo to "launchctl load com.shell.Updates.plist"

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
fi

# User Credentials
if [[ ! -d "${USER_DIR}" ]]; then
  mkdir -p "user" && cd "$_" && touch config &&
cat << EOF >> "${USER_DIR}/config"
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

# Apple Devs.
for packages (${UTILS_DIR}/opt/apple/*(N.)); do
  [[ -r "$packages" ]] && source "${packages}"
done

#
# Sets macOS.
#

# Ask before potentially overwriting files.
read -q "REPLY?macOS: update your macOS System Default.
Before continuing, to ensure all changes apply, head to System Preferences > Security & Privacy, then grant Full Disk Access to Terminal. Ready to proceed? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
 source "${UTILS_DIR}/opt/macOS/sysprefs"
else
  echo 'macOS: settings update skipped!'
fi

#
# Reboot OS.
#

read -q "REPLY?macOS: Done! Some of these changes require to reboot the system to take effect. Ready to proceed? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
  osascript -e 'tell app "loginwindow" to «event aevtrrst»'
else
  echo 'macOS: reboot OS aborted!'
fi
