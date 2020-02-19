#!/bin/bash

printf '\e[8;50;100t'

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

printf "checking for dialog... "
if [ ! -x "$(command -v dialog)" ]; then
    printf "${RED}missing${NC}\n"
    exit
else
    printf "${GREEN}found${NC}\n"
fi

printf "checking for arronax... "
if [ ! -x "$(command -v arronax)" ]; then
    printf "${RED}missing${NC}\n"
    exit
else
    printf "${GREEN}found${NC}\n"
fi

install="$HOME/.local/install"
desktop="$HOME/.local/share/applications"
workspace="$HOME/.local/share/appimgr"

install_notice="Select \"Yes\" to confirm the installation of appimgr.
This will:
- Create these folders if they dont already exist
    - $workspace
    - $install
    - $desktop
- Install $desktop/appimgr.desktop
- Install $workspace/cui.sh
"

dialog \
    --backtitle "Installation for https://github.com/au5ton/appimgr" \
    --title "Installation Notice" \
    --yesno "$install_notice" 30 80

# if approved
if [[ "$?" == "0" ]]; then
    printf "accepted"
else
    printf "exiting"
    exit 0
fi

mkdir -p "$workspace"
mkdir -p "$install"
mkdir -p "$desktop"

rm "$desktop/appimgr.desktop"

cat >"$desktop/appimgr.desktop" <<EOL
[Desktop Entry]
Name=appimgr
Comment=Small CUI for bringing organization to your AppImage programs
Terminal=true
Exec=${HOME}/.local/share/appimgr/cui.sh %f
Type=Application
Icon=/usr/share/icons/gnome/48x48/apps/gnome-settings-theme.png
Encoding=UTF-8
Hidden=false
NoDisplay=false
MimeType=application/x-appimage
EOL

chmod u+x "$desktop/appimgr.desktop"

rm "$workspace/cui.sh"
curl https://raw.githubusercontent.com/au5ton/appimgr/master/cui.sh -o "$workspace/cui.sh"
chmod u+x "$workspace/cui.sh"

message="The .desktop file for appimgr was installed to $desktop
Usage instructions:
In your file manager, select an .AppImage and click \"Open With Other Application\".
You should locate and use \"appimgr\".

Opening a .desktop file with appimgr will launch you into the wizard.

Accept any option to continue.
"

dialog --yesno "$message" 30 80