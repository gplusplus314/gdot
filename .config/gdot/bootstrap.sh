#!/bin/sh

# The intent of this file is to be able to run is on a brand new or otherwise
# reformatted machine with nothing else installed on it. It will kick off the
# rest of the configuration that is handled by other tools and/or scripts.
#
# Written in plain shellscript because, for the most part, "everything" already
# comes with a POSIX shell. It's "good enough" for bootstrapping.
#
# On macOS, this script first installs Homebrew and its prerequisites.
#
# Then this script installs Git, and then properly clones the GDot Git repo. 
# It defensively backs up existing dotfiles that conflict with the repo's and 
# defaults to aborting if backups already exist to avoid overwriting 
# potentially important dotfiles.
#
# Next, it installs packages via the OS-appropriate package manager and sets 
# system settings.
#
# Linux support is a TODO item.

# # Conventions:
set -e     # Fail on error
cd "$HOME" # Assume script is running in home dir

# # Config (either change these values or set them as env vars):

# ## Hostname
# If provided, the script will try to set the system's hostname. The provided
# string will also be used for host-specific config in the future, if any.
: "${GDOT_HOSTNAME:=}"

# ## Basic Git configuration:
# Will prompt the user later for these if they're empty. If both are provided,
# then the script will automatically set Git's configuration accordingly at
# the end of bootstrapping. If at least one is not set, no additional Git
# configuration will be set.
: "${GDOT_GIT_NAME:=}"  # git config user.name
: "${GDOT_GIT_EMAIL:=}" # git config user.email

# ## Sane defaults:
: "${GDOT_GIT_URI:=https://github.com/gplusplus314/gdot.git}"
: "${GDOT_HOME:=$HOME/.config/gdot}"
: "${GDOT_GIT_DIR:=$GDOT_HOME/.git_repo}"
: "${GDOT_BACKUP_DIR:=$GDOT_HOME/.backup}"

# ## Unlikely to change, but avaliable (set to 'y' for yes):
: "${GDOT_CLOBBER_BACKUPS:=n}"
: "${GDOT_SKIP_CONFIRM_CONFIG:=n}"
: "${GDOT_CLOBBER_GIT:=n}"
: "${GDOT_SKIP_CLONE:=n}"

# # Convenience:
prompt_yn() {
  printf "%s (y/n): " "$1"
  read response
  case "$response" in
    [Yy]*) return 0 ;;
    *) return 1 ;;
  esac
}
echo_err() {
  echo "$@" 1>&2
}
gdot() {
  git --git-dir="$GDOT_GIT_DIR" --work-tree="$HOME" "$@"
}

# # Setting and checking preconditions
#
# Make an effort to exit early. So let's check preconditions while we init
# some useful variables:

# ## Make the clone-skipping painfully obvious:
if [ "$GDOT_SKIP_CLONE" = "y" ]; then
  GDOT_GIT_URI="(skipping - will not clone)"
fi

# ## Used later before writing anything to disk:
confirm_config() {
  echo ""
  echo "Please confirm Gdot bootstrap configuration:"
  echo "  - Gdot Hostname (empty to skip): $GDOT_HOSTNAME"
  echo "  - Gdot Git URI to clone: $GDOT_GIT_URI"
  echo "  - Gdot home directory: $GDOT_HOME"
  echo "  - Gdot Git local repo directory: $GDOT_GIT_DIR"
  echo "  - Backup existing dotfiles to: $GDOT_BACKUP_DIR"
  echo "  - Clobber existing backups: $GDOT_CLOBBER_BACKUPS"
  echo "  - Git config user.name: $GDOT_GIT_NAME"
  echo "  - Git config user.email: $GDOT_GIT_EMAIL"

  if [ "$GDOT_SKIP_CONFIRM_CONFIG" = "y" ]; then
    echo "... GDOT_SKIP_CONFIRM_CONFIG is set; continuing."
    return 0
  else
    prompt_yn "... Is this correct?"
    return $?
  fi
}
prompt_config() {
  echo "Prompting for missing config options:"
  # Prompt for required config, if not already provided.
  if [ -z "$GDOT_HOSTNAME" ]; then
    printf "Enter your desired Hostname (empty to skip): "
    read GDOT_HOSTNAME
  fi
  if [ -z "$GDOT_GIT_NAME" ]; then
    printf "Enter your Git user.name (e.g. Johnny Appleseed): "
    read GDOT_GIT_NAME
  fi
  if [ -z "$GDOT_GIT_EMAIL" ]; then
    printf "Enter your Git user.email: "
    read GDOT_GIT_EMAIL
  fi
}

# Now let's try to exit early and do nothing.

# Which OS are we on?
OS=$(uname -o 2>/dev/null || uname -s)
if [ "$OS" = "Darwin" ]; then
  echo "Detected macOS"
elif [ "$OS" = "FreeBSD" ]; then
  echo "Detected FreeBSD"
else
  echo_err "Unexpected operating system: $OS"
  # TODO: Linux support
  exit 1
fi

# Which CPU architecture are we on?
architecture=$(uname -m)
if [ "$architecture" = "arm64" ]; then
  if [ "$OS" = "Darwin" ]; then
    BREW_PATH="${BREW_PATH:-/opt/homebrew}"
  fi
elif [ "$architecture" = "x86_64" ]; then
  if [ "$OS" = "Darwin" ]; then
    BREW_PATH="${BREW_PATH:-/usr/local}"
  else
    echo "Unexpected OS for $architecture: $OS"
    exit 1
  fi
elif [ "$architecture" = "amd64" ]; then
  if [ "$OS" = "FreeBSD" ]; then
    # FreeBSD amd64 is supported
  else
    echo "Unexpected OS for $architecture: $OS"
    exit 1
  fi
else
  echo_err "Unexpected architecture: $architecture"
  exit 1
fi

# Check for pre-existing backup files
if [ -d "$GDOT_BACKUP_DIR" ] && [ -n "$(ls -A "$GDOT_BACKUP_DIR" 2>/dev/null)" ]; then
  if [ "$GDOT_CLOBBER_BACKUPS" = "y" ]; then
    echo "Backup directory already contains files, but GDOT_CLOBBER_BACKUPS is enabled; continuing."
  else
    echo_err "Backup directory already contains files. Aborting operation to avoid overwriting backups."
    exit 1
  fi
fi

# Prompt user before removing the main directory if it exists
if [ -d "$GDOT_GIT_DIR" ]; then
  if [ "$GDOT_SKIP_CLONE" = "y" ]; then
    echo "GDOT_SKIP_CLONE is set; skipping Git clone"
  elif [ "$GDOT_CLOBBER_GIT" = "y" ]; then
    echo "$GDOT_GIT_DIR already exists, but GDOT_CLOBBER_GIT is set. Continuing."
  else
    if ! prompt_yn "$GDOT_GIT_DIR already exists. Do you want to delete it?"; then
      echo "Aborted; user doesn't want to delete Git repo."
      exit 1
    fi
  fi
fi

# Let the user sanity check the config
prompt_config
if ! confirm_config; then
  echo_err "Aborted; user said config was wrong."
  exit 1
fi

# Now let's install prereqs for bootstrapping:
if [ "$OS" = "Darwin" ]; then
  echo "Installing minimum dependencies to bootstrap macOS. This requires user attendance."
  echo "  - Installing Xcode command line tools..."
  until $(xcode-select --print-path >/dev/null 2>&1); do
    xcode-select --install >/dev/null 2>&1
    sleep 5
  done
elif [ "$OS" = "FreeBSD" ]; then
  # FreeBSD is good to go.
else
  echo "Unexpected operating system when installing minimum bootstrap dependencies: $OS"
  # TODO: Linux support
  exit 1
fi

# Cool. Now let's keep bootstrapping...

## Use Homebrew in macOS as much as possible.

if [ "$OS" = "Darwin" ]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "  - Installing Homebrew..."
    sudo -v
    /bin/sh -c "$(curl -fsSL \
      https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  # Enable brew for this shell session:
  eval "$($BREW_PATH/bin/brew shellenv)"
fi

if ! command -v git >/dev/null 2>&1; then
  echo "  - Installing Git..."
  if [ "$OS" = "Darwin" ]; then
    brew install git
  elif [ "$OS" = "FreeBSD" ]; then
    echo "FreeBSD needs to install git and update ports tree as root."
	TMP_SCRIPT="/tmp/gdot_freebsd_bootstrap.sh"
	cat << EOF > $TMP_SCRIPT
#!/bin/sh
echo "Installing git..."
pkg update
pkg install -y git
echo "Removing existing ports tree..."
rm -rf /usr/ports
echo "Cloning fresh ports tree from Git repository..."
git clone --depth 1 https://git.FreeBSD.org/ports.git /usr/ports
echo "Ports tree successfully updated."
EOF
    su -m root -c "$TMP_SCRIPT"
	rm $TMP_SCRIPT
  else
    echo "Unexpected operating system when installing git: $OS"
    # TODO: Linux support
    exit 1
  fi
fi

echo "  - Configuring Git..."
git config --global init.defaultBranch main
if [ -n "$GDOT_GIT_NAME" ] && [ -n "$GDOT_GIT_EMAIL" ]; then
  git config --global user.name "$GDOT_GIT_NAME"
  git config --global user.email "$GDOT_GIT_EMAIL"
  echo "    - user.name=$GDOT_GIT_NAME"
  echo "    - user.email=$GDOT_GIT_EMAIL"
else
  echo "    - Warning: Git configuration was skipped. Remember to manually configure Git (name, email, etc)"
fi

echo "Cloning Gdot Git repo..."
# Git clone Gdot
if [ "$GDOT_SKIP_CLONE" = "y" ]; then
  echo "  - GDOT_SKIP_CLONE is set; skipping Git clone"
else
  echo "  - Attempting clone..."
  mkdir -p "$GDOT_HOME"
  rm -rf "$GDOT_GIT_DIR"
  git clone --bare "$GDOT_GIT_URI" "$GDOT_GIT_DIR"
  echo "*" > "$GDOT_GIT_DIR/.gitignore" # stops `gdot add` from adding
  retries_remaining=2
  do_checkout() {
    echo "  - Attempting checkout..."
    gdot checkout > /dev/null 2>&1
    checkout_result=$?
    if [ $checkout_result -eq 0 ]; then
      echo "    - Dotfiles written to disk..."
    else
      echo "    - Backing up pre-existing dotfiles..."
      FILES=$(gdot checkout 2>&1 | grep -E "^\s+(\S+)$" | sed -E 's/^\s+//')
      if [ -n "$FILES" ]; then
        mkdir -p "$GDOT_BACKUP_DIR/$DIR"
        echo "*" > "$GDOT_BACKUP_DIR/.gitignore" # stops `gdot add` from adding
      fi
      for FILE in $FILES; do
        DIR=$(dirname "$FILE")
        mkdir -p "$GDOT_BACKUP_DIR/$DIR"
        mv "$FILE" "$GDOT_BACKUP_DIR/$FILE"
        echo "      $FILE"
      done
      if [ $retries_remaining -le 0 ]; then
        echo_err "Failed to backup dotfiles. Aborting."
        exit 1
      fi
      retries_remaining=$((retries_remaining - 1))
      do_checkout
    fi
  }
  do_checkout
fi
# Configure the Gdot Git repo to ignore untracked files
gdot config --local status.showUntrackedFiles no

echo "Setting hostname..."
if [ -n "$GDOT_HOSTNAME" ]; then
  if [ "$OS" = "Darwin" ]; then
    sudo scutil --set HostName "$GDOT_HOSTNAME"
    sudo scutil --set LocalHostName "$GDOT_HOSTNAME"
    sudo scutil --set ComputerName "$GDOT_HOSTNAME"
    dscacheutil -flushcache
    echo "  - Hostname has been changed to $GDOT_HOSTNAME"
  elif [ "$OS" = "FreeBSD" ]; then
    # change hostname in FreeBSD
    echo "FreeBSD needs to set hostname as root."
    # Set hostname permanently and immediately
    su -m root -c "sysrc hostname=\"$GDOT_HOSTNAME\" && hostname \"$GDOT_HOSTNAME\""
  else
    # TODO: Linux support
    echo "Unexpected OS when setting hostname: $OS"
    exit 1
  fi
else
  echo "  - Hostname not set. Skipping hostname-specific config."
fi

# Install packages
if [ "$OS" = "Darwin" ]; then
  echo "Executing Homebrew Brewfile..."
  brew bundle --file="$GDOT_HOME/Brewfile"
elif [ "$OS" = "FreeBSD" ]; then
  echo "Installing FreeBSD packages (requires root)..."
  su -m root -c "$GDOT_HOME/freebsd/pkg_install.sh"
else
  echo "Unexpected operating system when installing packages: $OS"
  # TODO: Linux support
  exit 1
fi

echo "Executing rustup-init..."
rustup-init -y
echo "Installing Cargo packages..."
(cd $GDOT_HOME && ./cargo_install.sh)

echo "Installing fonts..."
install_nerdfont() {
  # download URL from https://www.nerdfonts.com/font-downloads
  local ZIP_URL=$1

  local TEMP_DIR="/tmp/nerd-fonts"

  # TODO: FreeBSD and Linux (this is just for macOS)
  if [ "$OS" = "Darwin" ]; then
    local FONT_DIR="$HOME/Library/Fonts"

    mkdir -p "$TEMP_DIR"
    curl -L "$ZIP_URL" -o "$TEMP_DIR/SourceCodePro.zip"
    unzip "$TEMP_DIR/SourceCodePro.zip" -d "$TEMP_DIR"
    find "$TEMP_DIR" -name "*.ttf" -exec mv {} "$FONT_DIR" \;
    rm -rf "$TEMP_DIR"
  else
    echo "Skipping nerdfont installation for OS: $OS"
  fi
}
install_nerdfont "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/SourceCodePro.zip"
install_nerdfont "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip"

echo "Applying OS-specific settings..."
if [ "$OS" = "Darwin" ]; then
  echo "  - Setting macOS settings..."
  "$GDOT_HOME/macos/settings.sh"
  echo "  - Setting Brave as default browser..."
  open -W -a "Brave Browser" --args --make-default-browser
elif [ "$OS" = "FreeBSD" ]; then
  "$GDOT_HOME/freebsd/settings.sh"
else
  echo "Unexpected operating system when applying OS-specific settings: $OS"
  # TODO: Linux support
  exit 1
fi

echo ""
echo "Done. Bootstrapped configuration. Rebooting is recommended."
echo "Thank you for choosing Gdot. Buh-bye!"
