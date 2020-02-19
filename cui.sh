#!/bin/bash

printf '\e[8;50;100t'

name=$(basename "$1")
exe="$1"
prefix=""
install="$HOME/.local/install"
desktop="$HOME/.local/share/applications"

description="This tool will:
 - Copy the .AppImage file to a reserved directory
 - Assist you in generating a .desktop file for use with Gnome
 - Launching \`arronax\` for your .desktop file to make configurations

 See: https://github.com/au5ton/appimgr
 See: https://www.florian-diesch.de/software/arronax/

 The \"Prefix\" field creates a subfolder under the AppImage destination to prevent name conflicts.
"

# open fd
exec 3>&1

# Store data to $VALUES variable
VALUES=$(dialog --ok-label "Submit" \
	  --backtitle "Installing: $name" \
	  --title "AppImgr" \
	  --form "$description" \
30 80 0 \
	"AppImage:" 		1 1	"$exe"  	1 20 50 0 \
	"Prefix:"   		2 1	"$prefix"  	2 20 50 0 \
	"AppImage dest:" 	3 1	"$install" 	3 20 50 0 \
	"Desktop dest:"		4 1 "$desktop"	4 20 50 0 \
2>&1 1>&3)

cancelled=$?

if [ $cancelled -eq 1 ]; then
	printf "Dialog prompt was cancelled"
	exit
fi

# close fd
exec 3>&-

# display values just entered
echo "$VALUES"
i=0
while read -r line; do
   ((i++))
   declare var$i="${line}"
done <<< "${VALUES}"
#echo "var1=${var1}" # AppImage
#echo "var2=${var2}" # Prefix
#echo "var3=${var3}" # AppImage dest
#echo "var4=${var4}" # Desktop dest
exe=${var1}
prefix=${var2}
install=${var3}
desktop=${var4}

clear

printf "Creating install prefix...\t\t"
mkdir -p "$install/$prefix"
printf "$install/$prefix \n"

printf "Moving AppImage to install prefix...\t"
cp "$exe" "$install/$prefix/"
fullpath="$install/$prefix/$name"
printf "Done \n"

printf "Applying execution permissions...\t"
chmod u+x "$fullpath"
find $fullpath -printf "%f %u %m (%M) \n"

printf "Arronax install location? \t\t"
echo `which arronax`
printf "Starting Arronax in \t\t\t$desktop"
arronax --application "$fullpath" --dir "$desktop"