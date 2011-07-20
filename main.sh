#!/bin/bash
# Proper header for a Bash script.

# Check for root user login
if [ ! $( id -u ) -eq 0 ]; then
	echo "You must be root to run this script."
	echo "Please enter su before running this script again."
	exit
fi

USERNAME=$(logname)
IS_CHROOT=0

# The remastering process uses chroot mode.
# Check to see if this script is operating in chroot mode.
# If /home/$USERNAME exists, then we are not in chroot mode.
if [ -d "/home/$USERNAME" ]; then
	IS_CHROOT=0 # not in chroot mode
	DIR_DEVELOP=/home/$USERNAME/develop 
else
	IS_CHROOT=1 # in chroot mode
	DIR_DEVELOP=/usr/local/bin/develop 
fi

# Removing excess SLiM themes
rm -r /usr/share/slim/themes/debian-moreblue
rm -r /usr/share/slim/themes/debian-moreblue-orbit  
rm -r /usr/share/slim/themes/debian-spacefun  
rm -r /usr/share/slim/themes/default

echo "Replacing the SLiM settings"
rm /etc/slim.conf
cp $DIR_DEVELOP/slim/etc/slim.conf /etc
if [ $IS_CHROOT -eq 0 ]; then
	chown $USERNAME:users /etc/slim.conf
else
  	chown demo:users /etc/slim.conf
fi

rm /usr/share/slim/slim.template
cp $DIR_DEVELOP/slim/usr_share_slim/slim.template /usr/share/slim
if [ $IS_CHROOT -eq 0 ]; then
	chown $USERNAME:users /usr/share/slim/slim.template
else
  	chown demo:users /usr/share/slim/slim.template
fi