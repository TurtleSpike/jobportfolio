#!/bin/bash

clientname=$1
keysdir=`sudo find /home -type d -name keys -path "*/clients/*"`

cd /home/$USER/transfer
git pull origin master

cp $clientname.crt $keysdir 
cp `sudo find /home -type d -name easy-rsa`/ta.key $keysdir
sudo cp /etc/openvpn/server/ca.crt $keysdir

echo -e '\033[92m = = = = All necessary keys have been copied to the \033[4;92m'$keysdir'\033[m\033[92m directory = = = = \033[m'

sudo chown $USER:$USER $keysdir/*

echo -e '\033[92m = = = = Ownership of all \033[4;92m'$keysdir'\033[m\033[92m directory files has been changed to "'$USER':'$USER'" = = = = \033[m'
