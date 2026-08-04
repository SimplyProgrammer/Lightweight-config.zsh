#!/bin/sh

set -e

plugins="
zsh-autosuggestions
zsh-completions
zsh-syntax-highlighting
"

if command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
else
    SUDO=""
fi

inst() {
    if command -v apk >/dev/null 2>&1; then
        $SUDO apk update
        $SUDO apk add "$@"
    elif command -v apt-get >/dev/null 2>&1; then
        $SUDO apt-get update
        $SUDO apt-get install -y "$@"
    elif command -v apt >/dev/null 2>&1; then
        $SUDO apt update
        $SUDO apt install -y "$@"
    elif command -v dnf >/dev/null 2>&1; then
        $SUDO dnf install -y "$@"
    elif command -v yum >/dev/null 2>&1; then
        $SUDO yum install -y "$@"
    elif command -v pacman >/dev/null 2>&1; then
        $SUDO pacman -Sy --noconfirm "$@"
    elif command -v zypper >/dev/null 2>&1; then
        $SUDO zypper --non-interactive install "$@"
    elif command -v xbps-install >/dev/null 2>&1; then
        $SUDO xbps-install -Sy "$@"
    elif command -v emerge >/dev/null 2>&1; then
        $SUDO emerge "$@"
    elif command -v opkg >/dev/null 2>&1; then
        $SUDO opkg update
        $SUDO opkg install "$@"
    else
        echo "Unsupported package manager."
        exit 1
    fi
}

confirm() {
    printf "%s [Y/n] " "${1:-Are you sure?}"
    read -r ans
    case "$ans" in
        ""|[Yy]*) return 0 ;;
        *) return 1 ;;
    esac
}

create_admin_user() {
    USR="$1"
    ZSH_PATH="$(command -v zsh)"
    ADMIN_GROUP=root

    if grep -q '^sudo:' /etc/group; then
        ADMIN_GROUP=sudo
    elif grep -q '^wheel:' /etc/group; then
        ADMIN_GROUP=wheel
    fi
    
    if command -v adduser >/dev/null 2>&1; then
        $SUDO adduser --ingroup "$ADMIN_GROUP" --shell "$ZSH_PATH" "$USR"
    elif command -v useradd >/dev/null 2>&1; then
        $SUDO useradd -m -g "$ADMIN_GROUP" -s "$ZSH_PATH" "$USR"
    else
        echo "No user creation utility found."
        exit 1
    fi

    echo "User '$USR' created."
    echo "You may wish to set a password with:"
    echo "    passwd $USR"
}

inst git zsh

TARGET_USER="$(id -un)"
TARGET_HOME="$HOME"
if [ "$(id -u)" -eq 0 ] || [ "$1" = "newuser" ]; then
    echo "Running as $TARGET_USER."
    printf "Create a separate login user for Zsh? (leave blank to continue as $TARGET_USER): "
    read -r NEWUSER

    if [ -n "$NEWUSER" ]; then
        create_admin_user "$NEWUSER"
        TARGET_USER="$NEWUSER"
        TARGET_HOME=$(eval echo "~$TARGET_USER")
    fi
fi

PLUGIN_DIR="/usr/share/zsh/plugins"
if ! mkdir -p "$PLUGIN_DIR" 2>/dev/null; then
    PLUGIN_DIR="$HOME/.local/share/zsh/plugins"
    mkdir -p "$PLUGIN_DIR"
fi

for plugin in $plugins; do # Clone plugins
    if [ ! -d "$PLUGIN_DIR/$plugin" ]; then
        $SUDO git clone "https://github.com/zsh-users/$plugin" "$PLUGIN_DIR/$plugin"
    fi
done

$SUDO ./build.sh

cp -rf .zshrc .zprofile .zshenv "$TARGET_HOME/"
chmod u+x "$TARGET_HOME/.zshrc" "$TARGET_HOME/.zprofile"
$SUDO chown "$TARGET_USER" "$TARGET_HOME/.zshrc" "$TARGET_HOME/.zprofile" "$TARGET_HOME/.zshenv"

if [ "$(id -un)" = "$TARGET_USER" ] && command -v chsh >/dev/null 2>&1 && confirm "Change $TARGET_USER's default shell to zsh?"; then
    SHELL_PATH=$(command -v zsh)
    $SUDO chsh -s "$SHELL_PATH" "$TARGET_USER"
fi

if [ "$TARGET_USER" != "$(id -un)" ]; then
    echo
    echo "To start using the new account with zsh:"
    echo "    su - $TARGET_USER"
else
    exec zsh
fi
