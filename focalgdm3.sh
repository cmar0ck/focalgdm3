#!/bin/bash

codename=$(cat /etc/os-release | grep UBUNTU_CODENAME | cut -d = -f 2)

if [ "$codename" == "focal" ]
then
source="/usr/share/gnome-shell/theme/Yaru/gnome-shell-theme.gresource"
else
echo "
----------------------------------------
Sorry, this script only works with Ubuntu 20.04.
Exiting...
----------------------------------------"
exit 1
fi

pkg=$(dpkg -l | grep libglib2.0-dev >/dev/null && echo "yes" || echo "no")
if [ "$pkg" == "no" ]
then
echo "
-----------------------------------------------------------------------------------------------------
Sorry, the package 'libglib2.0-dev' is not installed. Please install it (-> sudo apt install -y libglib2.0-dev) and run this script again.
Exiting...
-----------------------------------------------------------------------------------------------------"
exit 1
fi

############################################################################################
case "$1" in ###############################################################################
############################################################################################
--set)
############################################################################################

if [ "$UID" != "0" ]
then
echo "This script must be run with sudo."
exit 1
fi

echo "
-------------------------------------------------------------------------------------------------------
				###############################
				#           FOCALGDM3         #
				###############################

This script allows you to change the background color or background image of Ubuntu 20.04's login screen

>>>>>>>>>Don't forget to reboot or re-login for the changes to take effect.<<<<<<<<<<<<

Continue (y/n)? (Type 'n' to exit, or press 'y' to proceed.)
-------------------------------------------------------------------------------------------------------"
read answer

if [ "$answer" == "n" ] || [ "$answer" == "N" ]
then
echo "Exiting..."
exit 1
fi

echo "
Please choose what you'd like to use as a background:
-----------------------------------------
1. Image		2. Color
-----------------------------------------"
read a

if [ -z $a ]
then
echo "No option selected.
Exiting..."
exit 1
fi

if [ "$a" == "1" ]
then
echo "Enter path of background image (to be displayed on login screen)
----------------------------------------------------
Example 1: /usr/share/backgrounds/2.jpg
Example 2: /usr/local/share/backgrounds/spaceship.png
Example 3: /home/focal/Downloads/myBG.jpeg
----------------------------------------------------"
read b

elif [ "$a" == "2" ]
then
echo "
Enter hex color code (to be used as background color of login screen, you can pick ones here: https://www.color-hex.com/)
-------------------------------------------------------------------------------------------------------------------------
Example 1: #00ff00 (lime green)
Example 2: #ffccaa (light orange)
Example 3: #456789 (light blue)
Example 4: #112233 (dark blue)
Example 5: #FF00FF (pink)
Example 6: #000000 (black)
-------------------------------------------------------------------------------------------------------------------------"
read c
fi

if [ -z $b ] && [ -z $c ]
then
echo "No input provided.
Exiting..."
exit 1
fi

if [ -z $c ]
then
color="#042320"
else
color="$c"
fi

if ! [ -z $c ]
then
    	if ! [[ $c =~ ^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$ ]]; then
    	echo "
------------------------------------------------------------------------------------------------------------
    	Sorry, that's not a valid hex color. Please choose a valid hex color, then run this script again.
------------------------------------------------------------------------------------------------------------"
    	exit 1
    	fi
fi

if ! [ -z $b ]
then
	if ! [ -e $b ]; then
	echo "
------------------------------------------------------------------------------------------------------------
Image does not exist or path to image is incorrect, script-defined background color is going to be used for now.
Please write down the correct path of the image and then run this script again.
------------------------------------------------------------------------------------------------------------"
	fi
fi

source="/usr/share/gnome-shell/theme/Yaru/gnome-shell-theme.gresource"
prefix="/org/gnome/shell/theme"
dest="/usr/local/share/gnome-shell/theme/focalgdm3"

install -D /dev/null $dest/gdm3.css
install -D /dev/null $dest/focalgdm3.gresource.xml
install -d $dest/icons/scalable/actions

gresource extract $source $prefix/gdm3.css > $dest/original.css
gresource extract $source $prefix/checkbox.svg > $dest/checkbox.svg
gresource extract $source $prefix/checkbox-off.svg > $dest/checkbox-off.svg
gresource extract $source $prefix/checkbox-focused.svg > $dest/checkbox-focused.svg
gresource extract $source $prefix/checkbox-off-focused.svg > $dest/checkbox-off-focused.svg
gresource extract $source $prefix/toggle-on.svg > $dest/toggle-on.svg
gresource extract $source $prefix/toggle-off.svg > $dest/toggle-off.svg
gresource extract $source $prefix/icons/scalable/actions/pointer-drag-symbolic.svg > $dest/icons/scalable/actions/pointer-drag-symbolic.svg
gresource extract $source $prefix/icons/scalable/actions/keyboard-enter-symbolic.svg > $dest/icons/scalable/actions/keyboard-enter-symbolic.svg
gresource extract $source $prefix/icons/scalable/actions/keyboard-hide-symbolic.svg > $dest/icons/scalable/actions/keyboard-hide-symbolic.svg
gresource extract $source $prefix/icons/scalable/actions/pointer-secondary-click-symbolic.svg > $dest/icons/scalable/actions/pointer-secondary-click-symbolic.svg
gresource extract $source $prefix/icons/scalable/actions/keyboard-shift-filled-symbolic.svg > $dest/icons/scalable/actions/keyboard-shift-filled-symbolic.svg
gresource extract $source $prefix/icons/scalable/actions/keyboard-caps-lock-filled-symbolic.svg > $dest/icons/scalable/actions/keyboard-caps-lock-filled-symbolic.svg
gresource extract $source $prefix/icons/scalable/actions/pointer-primary-click-symbolic.svg > $dest/icons/scalable/actions/pointer-primary-click-symbolic.svg
gresource extract $source $prefix/icons/scalable/actions/keyboard-layout-filled-symbolic.svg > $dest/icons/scalable/actions/keyboard-layout-filled-symbolic.svg
gresource extract $source $prefix/icons/scalable/actions/eye-not-looking-symbolic.svg > $dest/icons/scalable/actions/eye-not-looking-symbolic.svg
gresource extract $source $prefix/icons/scalable/actions/pointer-double-click-symbolic.svg > $dest/icons/scalable/actions/pointer-double-click-symbolic.svg
gresource extract $source $prefix/icons/scalable/actions/eye-open-negative-filled-symbolic.svg > $dest/icons/scalable/actions/eye-open-negative-filled-symbolic.svg

echo '@import url("resource:///org/gnome/shell/theme/original.css");
  #lockDialogGroup {
  background: '$color' url(file://'$b');
  background-repeat: no-repeat;
  background-size: cover;;
  background-position: center; }' > $dest/gdm3.css

echo '<?xml version="1.0" encoding="UTF-8"?>
<gresources>
  <gresource prefix="/org/gnome/shell/theme">
    <file>original.css</file>
    <file>gdm3.css</file>
    <file>toggle-off.svg</file>
    <file>checkbox-off.svg</file>
    <file>toggle-on.svg</file>
    <file>checkbox-off-focused.svg</file>
    <file>checkbox-focused.svg</file>
    <file>checkbox.svg</file>
    <file>icons/scalable/actions/pointer-drag-symbolic.svg</file>
    <file>icons/scalable/actions/keyboard-enter-symbolic.svg</file>
    <file>icons/scalable/actions/keyboard-hide-symbolic.svg</file>
    <file>icons/scalable/actions/pointer-secondary-click-symbolic.svg</file>
    <file>icons/scalable/actions/keyboard-shift-filled-symbolic.svg</file>
    <file>icons/scalable/actions/keyboard-caps-lock-filled-symbolic.svg</file>
    <file>icons/scalable/actions/pointer-primary-click-symbolic.svg</file>
    <file>icons/scalable/actions/keyboard-layout-filled-symbolic.svg</file>
    <file>icons/scalable/actions/eye-not-looking-symbolic.svg</file>
    <file>icons/scalable/actions/pointer-double-click-symbolic.svg</file>
    <file>icons/scalable/actions/eye-open-negative-filled-symbolic.svg</file>
  </gresource>
</gresources>' > $dest/focalgdm3.gresource.xml

cd $dest
glib-compile-resources focalgdm3.gresource.xml
mv focalgdm3.gresource ..
rm -r $dest
update-alternatives --quiet --install /usr/share/gnome-shell/gdm3-theme.gresource gdm3-theme.gresource /usr/local/share/gnome-shell/theme/focalgdm3.gresource 0
update-alternatives --quiet --set gdm3-theme.gresource /usr/local/share/gnome-shell/theme/focalgdm3.gresource

check=$(update-alternatives --query gdm3-theme.gresource | grep Value | grep /usr/local/share/gnome-shell/theme/focalgdm3.gresource >/dev/null && echo "pass" || echo "fail")
if [ "$check" == "pass" ]
then
echo "
				     		---------
						|Success|
						---------"
else
echo Failure
exit 1
fi
;;
############################################################################################
--reset) ###################################################################################
############################################################################################

if [ -e /usr/local/share/gnome-shell/theme/focalgdm3.gresource ]
then
rm /usr/local/share/gnome-shell/theme/focalgdm3.gresource
update-alternatives --quiet --set gdm3-theme.gresource "$source"
cd /usr/local/share
rmdir --ignore-fail-on-non-empty -p gnome-shell/theme
echo "
				     		---------------
						|Reset Success|
						---------------"
else
echo "
-----------------------------------------------------------------------------
No need, already reset. (Or unlikely background is not set using this script.)
-----------------------------------------------------------------------------"
exit 1
fi
;;
############################################################################################
*) #########################################################################################
############################################################################################
echo "Use with parameters '--set' or '--reset'; 
Examples: 'focalgdm3.sh --set' or 'focalgdm3.sh --reset'"
exit 1
esac
