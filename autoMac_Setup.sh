#!/usr/bin/env bash

# TODO: change every shebang to zsh
# TODO: search how to send inpunt inside a script (like when I have to press enter or type y/n to continue)
# TODO: create a readme with all the steps to do manually ([x] = done, [ ] = to do) and open it at the beginning of the script
# TODO initial choice if I want to save this setup or if I want to autoMac_Setup (smt like a homebrew app -> brew install autoMac, autoMac init my-config-file, autMac save filename)
# https://www.youtube.com/watch?v=fbyrLo6yx8M

echo "\033[0;36m Welcome $(whoami)! 🦆 \n my-mac-setup's started! 🚀 \033[0m"
# sudo -v #preemptively asking root permissions :)

# TODO write a script that copies all file to another folder for icloud backup every 15/20 minutes
# https://unix.stackexchange.com/questions/119069/cron-vs-sleep-which-is-the-better-one-in-terms-of-efficient-cpu-memory-utiliz
# https://www.youtube.com/watch?v=H8Z5AgU7zWQ
# https://apple.stackexchange.com/questions/450495/how-do-i-schedule-a-job-to-run-every-15-minutes-on-mac-os-big-sur


echo "\033[0;34m Setting up touch id for sudo 🖐 \033[0m"
sudo_settings=$'# sudo: auth account password session\\nauth       sufficient     pam_tid.so\\nauth       sufficient     pam_smartcard.so\\nauth       required       pam_opendirectory.so\\naccount    required       pam_permit.so\\npassword   required       pam_deny.so\\nsession    required       pam_permit.so'
echo $sudo_settings > /etc/pam.d/sudo

sh set-preferences-before-apps.sh

sh install-vs.sh

# sh install-docker.sh

sh install-apps.sh

echo "\033[0;34m If all apps are installed by now...open them to setup some preferences 🔩 \033[0m"
read -p "Press enter to continue 😬"
open -a enki
open -a accelerate
open -a piper
open -a etoro
open -a nigthshift
open -a pages
open -a keynote
open -a numbers
open -a dropover
open -a copyclip

echo "\033[0;34m The next script will rename all to lowercase...and remove directories i don't use 🔡 \033[0m"
for f in *; do mv "$f" "$f.tmp"; mv "$f.tmp" "`echo $f | tr "[:upper:]" "[:lower:]"`"; done
rm -r movies && rm bin && rmdir applicazioni

echo "\033[0;34m Syncing OneDrive on desktop... 🌥 \033[0m"
rm -r /Users/enrico/Desktop && ln -s -n /Users/enrico/onedrive\ -\ unige.it /Users/enrico/Desktop

echo "\033[0;34m Adding my executable scripts to the local user bin directory 🤓 \033[0m"
mkdir ../../usr/local/bin 
cp onedrive\ -\ unige.it/my_projects/copy-of-bin/* ../../usr/local/bin
chmod -R 777 ../../usr/local/bin/*

echo "\033[0;34m At this point Visual Studio for mac should be installed, so I'll remove the installer app 😏 \033[0m"
rm -rf ../../Applications/Install\ Visual\ Studio\ for\ Mac.app

echo -e "\033[1;31m Wait for the UTM's virtual machine download from OneDrive to be done! 🛑 \n Next I will move VMs to the right directory 📂 \033[0m"
read -p "Press enter to continue 😬"
mv onedrive\ -\ unige.it/Windows-arm.utm /Users/$LOGNAME/Library/Containers/com.utmapp.UTM/Data/Documents
mv onedrive\ -\ unige.it/ubuntu-arm.utm /Users/$LOGNAME/Library/Containers/com.utmapp.UTM/Data/Documents

sh add-tags.sh

echo "\033[0;34m Cleainig up some stuff... 🧹 \033[0m"
brew cleanup #remove old versions of installed apps

echo "\033[0;34m Finally I'll execute a script to check if it's all installed correctly 🥰 \033[0m"
cd /Applications
ls >> /Users/$LOGNAME/app-list.txt
cd
actual=$(cat app-list.txt)
expected=$(cat "automated-macos-setup/app-list.txt")
status=$(cmp --silent -- "$actual" "$expected")

if status==0; then
    echo -e "\033[0;32m Nothing went wrong! 😄 \033[0m"
    rm app-list.txt
else
    echo -e "\033[1;31m Something went wrong...check which apps is not in actual-app-list.txt 🙁 \033[0m"
    open automated-macos-setup/app-list.txt
    open app-list.txt
    exit
fi

sh add-persistent-apps.sh

echo "\033[0;34m Organizing the launchpad 📱 \033[0m"
cp .launchpad.yaml $HOME/.launchpad.yaml
lporg load /Users/enrico/.launchpad.yaml


read -p "Press enter to restart MacOs 🔁"
shutdown -r now
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Old script: 
# brew install git
# brew install --cask xampp
# brew install --cask atom
# brew install --cask pgadmin4
# brew install --cask github
# brew install --cask xquartz
# brew install exiftool
# brew install --cask eclipse-java
# brew install --cask warp; sudo open -a warp
# defaults write com.apple.dock persistent-apps -array-add "${Applications}Warp.app${end}"

# /usr/bin/automator ~/OneDrive\ -\ unige.it/scrivania/my_projects/automated_setup/OneDrive_aliasses_for_Desktop.workflow

# ANSI escape codes:
# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37

# curl -o /tmp/hblock 'https://raw.githubusercontent.com/hectorm/hblock/v3.4.0/hblock' \
#   && echo '4031d86cd04fd7c6cb1b7e9acb1ffdbe9a3f84f693bfb287c68e1f1fa2c14c3b  /tmp/hblock' | shasum -c \
#   && sudo mv /tmp/hblock /usr/local/bin/hblock \
#   && sudo chown 0:0 /usr/local/bin/hblock \
#   && sudo chmod 755 /usr/local/bin/hblock

# To instead install a .pkg, use this command:
# sudo installer -package /path/to/package -target "/Volumes/Macintosh HD"

# less fun alternative to manually install VS for mac
# sudo open -W  Downloads/visualstudioformacinstaller-*.dmg

# set catalina desktop start
    # file="/System/Library/Desktop Pictures/Catalina.madesktop"
    # defaults write com.apple.desktop Background '{default = {ImageFilePath = "/System/Library/Desktop Pictures/Catalina.madesktop";};}'
# end

# curl wttr.in/genova