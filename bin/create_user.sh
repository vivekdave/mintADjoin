#!/bin/bash
# ----------------------------------------------------------
# Create a new user.
#
# Random Icon .face
# Must run as root
# Add files to /etc/skel
# ----------------------------------------------------------
# Change this for new user
USERNAME=template
SHELL=/bin/bash # Must specify a shell or user does not appear on login screen.
# Where are the user icons stored?
ICONS=(/usr/share/cinnamon/faces/*)
# Get random user icon
function getIcon
{
   idx=$[ $RANDOM % ${#ICONS[@]} ]
   echo ${ICONS[$idx]}
}
# Create new user
sudo useradd -m -p $(perl -e 'print crypt("Apple@17", "blue")') -s $SHELL "$USERNAME"
sudo echo "$USERNAME":"Apple@17" | chpasswd
# Copy user icon to .face in new user's home
icon=$(getIcon)
sudo cp $icon /home/$USERNAME/.face
# Change permissions for privacy
sudo chmod 700 /home/$USERNAME
# Copy icon into system dir so it appears on login screen
sudo cp "/home/$USERNAME/.face" "/var/lib/AccountsService/icons/$USERNAME"
