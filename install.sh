#!/bin/bash

printf '\e[8;50;100t'

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

printf "checking for dialog... "
if [ which dialog ]; then
    printf "${RED}missing${NC}\n"
    exit
else
    printf "${GREEN}found${NC}\n"
fi

printf "checking for arronax... "
if [ which arronax ]; then
    printf "${RED}missing${NC}\n"
    exit
else
    printf "${GREEN}found${NC}\n"
fi

install="$HOME/.local/install"
desktop="$HOME/.local/share/applications"
workspace="$HOME/.local/share/appimgr"

install_notice="Select \"Yes\" to confirm the installation of appimgr."

dialog --yesno "$install_notice" 30 80

if [ ! echo $? ]; then
    exit
fi

mkdir -p "$workspace"
mkdir -p "$install"
mkdir -p "$desktop"

#cp appimgr.desktop "$desktop/appimgr.desktop"
curl https://raw.githubusercontent.com/au5ton/appimgr/master/appimgr.desktop -o "$desktop/appimgr.desktop"
#cp cui.sh "$workspace/"
curl https://raw.githubusercontent.com/au5ton/appimgr/master/cui.sh -o "$workspace/cui.sh"

message="The .desktop file for appimgr was installed to $desktop
Usage instructions:
In your file manager, select an .AppImage and click \"Open With Other Application\".
You should locate and use \"appimgr\".

Opening a .desktop file with appimgr will launch you into the wizard.
"

dialog --yesno "$message" 10 40