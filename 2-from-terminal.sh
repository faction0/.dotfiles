#!/bin/bash

DI_YOGURT_OKAY=0
DI_FIREFOX_CONFIG_OKAY=0
DI_CONFIG_LINK_OKAY=0
DI_SERVICE_ENABLING_OKAY=0
DI_GIT_CONFIG_OKAY=0

load_progress() {
    if [[ ! -f dotfiles_info.cfg ]]; then
        save_progress
    fi

    source dotfiles_info.cfg
}

save_progress() {
    cat > dotfiles_info.cfg <<EOF
DI_YOGURT_OKAY=$DI_YOGURT_OKAY
DI_FIREFOX_CONFIG_OKAY=$DI_FIREFOX_CONFIG_OKAY
DI_CONFIG_LINK_OKAY=$DI_CONFIG_LINK_OKAY
DI_SERVICE_ENABLING_OKAY=$DI_SERVICE_ENABLING_OKAY
DI_GIT_CONFIG_OKAY=$DI_GIT_CONFIG_OKAY
EOF
}

load_progress

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ASS_DIR="${SCRIPT_DIR}/assets"


die() {
    echo "Error at line ${BASH_LINENO[0]}"
    save_progress
    exit
}

yogurt() {
    echo "======== yogurt ========" # yo gurt
    DI_YOGURT_OKAY=0

    if ! command -v yay >/dev/null; then

        if [[ ! -d "yay-bin" || -z "$(ls -A yay-bin 2>/dev/null)" ]]; then
            echo "Cloning yay-bin..."
            git clone https://aur.archlinux.org/yay-bin.git
        fi

        cd yay-bin
        makepkg -si
        cd ..

        command -v yay >/dev/null || die
    fi

    yay_or_fail() {
    while [ $# -gt 0 ]; do
        cmd="$1"
        pkg="$2"
        shift 2

        if ! command -v "$cmd" >/dev/null; then
            yay -S --needed "$pkg" || die 
            command -v "$cmd" >/dev/null || die
        fi
        done
    }

    yay_or_fail "portmaster"  "portmaster-bin"
    yay_or_fail "vscodium"    "vscodium-bin"
    yay_or_fail "vesktop"     "vesktop-bin"
    yay_or_fail "brave"       "brave-bin"

    if ! command -v "com.saivert.pwvucontrol" > /dev/null; then
        flatpak install com.saivert.pwvucontrol || die
        command -v "com.saivert.pwvucontrol" >/dev/null || die

    yay -S --needed nvidia-580xx-utils nvidia-580xx-dkms nvidia-580xx-settings lib32-nvidia-580xx-utils

    DI_YOGURT_OKAY=1
    save_progress

    echo -e "okay\n"
}

[[ $DI_YOGURT_OKAY -eq 1 ]] || yogurt  


firefox_config() {
    echo '======== firefox theme ========'
    DI_FIREFOX_CONFIG_OKAY=0

    echo 'quit firefox'
    firefox
    
    local profile_name="$(grep -m1 '^Default=' ${HOME}/.mozilla/firefox/profiles.ini | cut -d= -f2)"
    local profile_path="${HOME}/.mozilla/firefox/${profile_name}"

    mkdir -p "$profile_path/chrome"
    cp "${SCRIPT_DIR}/assets/firefox-userchrome.css" "$profile_path/chrome/userChrome.css"
    cp "${SCRIPT_DIR}/assets/firefox-userjs.js" "$profile_path/user.js"

    echo 'follow instructions'
    firefox "${SCRIPT_DIR}/assets/firefox-config.html"

    [[ -f "$HOME/Downloads/firefox-theme-success" ]] || die

    rm "$HOME/Downloads/firefox-theme-success"

    xdg-settings set default-web-browser firefox.desktop

    DI_FIREFOX_CONFIG_OKAY=1
    save_progress

    echo -e "okay\n"
}

[[ $DI_FIREFOX_CONFIG_OKAY -eq 1 ]] || firefox_config  

config_link() {
    echo '======== config linking ========'
    DI_CONFIG_LINK_OKAY=0

    mkdir -p ~/.config/i3
    mkdir -p ~/.config/alacritty
    mkdir -p ~/.config/dunst
    mkdir -p ~/.config/mpd
    mkdir -p ~/.config/rmpc
    mkdir -p ~/.config/rmpc/themes
    mkdir -p ~/.config/gtk-3.0

    cp "${ASS_DIR}/i3-conf.sh"          "$HOME/.config/i3/config"
    cp "${ASS_DIR}/alacritty-conf.toml" "$HOME/.config/alacritty/alacritty.toml"
    cp "${ASS_DIR}/bash-config.sh"      "$HOME/.bashrc"
    cp "${ASS_DIR}/dunst-config.ini"    "$HOME/.config/dunst/dunstrc"
    cp "${ASS_DIR}/tmux-conf.conf"      "$HOME/.tmux.conf"
    cp "${ASS_DIR}/mpd-conf.conf"       "$HOME/.config/mpd/mpd.conf"
    cp "${ASS_DIR}/rmpc-config.ron"     "$HOME/.config/rmpc/config.ron"
    cp "${ASS_DIR}/rmpc-theme.ron"      "$HOME/.config/rmpc/themes/main.ron"
    cp "${ASS_DIR}/gtk-settings.ini"    "$HOME/.config/gtk-3.0/settings.ini"

    DI_CONFIG_LINK_OKAY=1
    save_progress
    echo -e "okay\n"
}

[[ $DI_CONFIG_LINK_OKAY -eq 1 ]] || config_link

service_enabling() {
    echo '======== service enabling ========'
    DI_SERVICE_ENABLING_OKAY=0

    systemctl enable --now portmaster
    systemctl --user enable --now pipewire
    systemctl --user enable --now pipewire-pulse

    DI_SERVICE_ENABLING_OKAY=1
    save_progress
    echo -e "okay\n"
}

[[ $DI_SERVICE_ENABLING_OKAY -eq 1 ]] || service_enabling

git_config() {
    echo '======== setting up git ========'
    DI_GIT_CONFIG_OKAY=0

    git config --global user.name "faction0"
    git config --global user.email "faction0@protonmail.com"
    git config --global init.defaultBranch "main"

    DI_GIT_CONFIG_OKAY=1
    save_progress
    echo -e "okay\n"
}

[[ $DI_GIT_CONFIG_OKAY -eq 1 ]] || git_config



