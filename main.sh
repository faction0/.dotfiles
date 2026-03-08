#!/bin/bash

DI_FONT_LINK_OKAY=0
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
DI_FONT_LINK_OKAY=$DI_FONT_LINK_OKAY
DI_YOGURT_OKAY=$DI_YOGURT_OKAY
DI_FIREFOX_CONFIG_OKAY=$DI_FIREFOX_CONFIG_OKAY
DI_CONFIG_LINK_OKAY=$DI_CONFIG_LINK_OKAY
DI_SERVICE_ENABLING_OKAY=$DI_SERVICE_ENABLING_OKAY
DI_GIT_CONFIG_OKAY=$DI_GIT_CONFIG_OKAY
EOF
}

load_progress

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

link_function() {
    local src="$1"
    local dst="$2"
    local use_sudo=""

    [[ -n $3 ]] && use_sudo="sudo"

    $use_sudo ln -s "$src" link.tmp
    $use_sudo mv -Tf link.tmp "$dst"

    [[ "$($use_sudo readlink -f "$dst")" == "$(readlink -f "$src")" ]] || die
}

die() {
    echo "Error at line ${BASH_LINENO[0]}"
    save_progress
    exit
}

font_link() {
    echo "======== linking fonts ========"
    DI_FONT_LINK_OKAY=0

    7z x "${SCRIPT_DIR}/assets/0xProto.7z" "-o${SCRIPT_DIR}/assets/"
    7z x "${SCRIPT_DIR}/assets/CommitMono.7z" "-o${SCRIPT_DIR}/assets/"

    link_function "${SCRIPT_DIR}/assets/0xProto" "/usr/share/fonts/0xProto" "yes"
    link_function "${SCRIPT_DIR}/assets/CommitMono" "/usr/share/fonts/CommitMono" "yes"

    DI_FONT_LINK_OKAY=1
    save_progress

    echo -e "okay\n"
}

[[ $DI_FONT_LINK_OKAY -eq 1 ]] || font_link  

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

    if ! command -v portmaster >/dev/null; then
        yay -S portmaster-bin

        command -v portmaster >/dev/null || die
    fi

    if ! command -v vscodium >/dev/null; then
        yay -S vscodium-bin

        command -v vscodium >/dev/null || die
    fi

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
    link_function "${SCRIPT_DIR}/assets/firefox-userchrome.css" "$profile_path/chrome/userChrome.css"
    link_function "${SCRIPT_DIR}/assets/firefox-userjs.js" "$profile_path/user.js"

    echo 'follow instructions'
    firefox "${SCRIPT_DIR}/assets/firefox-color.html"

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

    mkdir -p ~/.config/alacritty
    mkdir -p ~/.config/dunst/
    mkdir -p ~/.config/mpd
    mkdir -p ~/.config/rmpc
    mkdir -p ~/.config/rmpc/themes

    link_function "${SCRIPT_DIR}/assets/i3-conf.sh" "$HOME/.config/i3/config"
    link_function "${SCRIPT_DIR}/assets/alacritty-conf.toml" "$HOME/.config/alacritty/alacritty.toml"
    link_function "${SCRIPT_DIR}/assets/bash-config.sh" "$HOME/.bashrc"
    link_function "${SCRIPT_DIR}/assets/dunst-config.ini" "$HOME/.config/dunst/dunstrc"
    link_function "${SCRIPT_DIR}/assets/tmux-conf.conf" "$HOME/.tmux.conf"
    link_function "${SCRIPT_DIR}/assets/mpd-conf.conf" "$HOME/.config/mpd/mpd.conf"
    link_function "${SCRIPT_DIR}/assets/rmpc-config.ron" "$HOME/.config/rmpc/config.ron"
    link_function "${SCRIPT_DIR}/assets/rmpc-theme.ron" "$HOME/.config/rmpc/themes/main.ron"

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

