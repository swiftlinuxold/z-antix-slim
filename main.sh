#!/bin/bash
# Proper header for a Bash script.

# Check for root user login
if [ ! $( id -u ) -eq 0 ]; then
	echo "You must be root to run this script."
	echo "Please enter su before running this script again."
	exit 2
fi

IS_CHROOT=0 # changed to 1 if and only if in chroot mode
USERNAME=""
DIR_DEVELOP=""

# The remastering process uses chroot mode.
# Check to see if this script is operating in chroot mode.
# /srv directory only exists in chroot mode
if [-d "/srv"]; then
	IS_CHROOT=1 # in chroot mode
	DIR_DEVELOP=/usr/local/bin/develop 
else
	USERNAME=$(logname) # not in chroot mode
	DIR_DEVELOP=/home/$USERNAME/develop 
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

FILE_TO_COPY=$DIR_DEVELOP/slim/usr_local_bin/user-management

echo "Changing /usr/local/bin/user-management"
rm /usr/local/bin/user-management
cp $FILE_TO_COPY /usr/local/bin/
chown root:root /usr/local/bin/user-management

echo "Changing /usr/share/antiX/localisation/en/local-bin/user-management"
rm /usr/share/antiX/localisation/en/local-bin/user-management
cp $FILE_TO_COPY /usr/share/antiX/localisation/en/local-bin/
if [ $IS_CHROOT -eq 0 ]; then
	chown $USERNAME:users /usr/share/antiX/localisation/en/local-bin/user-management
else
  	chown demo:users /usr/share/antiX/localisation/en/local-bin/user-management
fi

exit 0
