#!/bin/bash

rsadir=`sudo find /home -type d -name easy-rsa`
servername=$1
transfer=/home/$USER/transfer

cd $rsadir
./easyrsa gen-req $servername nopass

if [ $? -eq 0 ]
then
  echo -e '\033[92m = = = = Server certificate request "'$servername'.req" and server key "'$servername'.key" have been created = = = = \033[m'
else
  echo -e '\033[91m = = = = Server certificate request and server key have NOT been created = = = = \033[m'
  exit 1
fi

sudo cp $rsadir/pki/private/$servername.key /etc/openvpn/server
cp $rsadir/pki/reqs/$servername.req $transfer
git pull origin master
git add .
git commit -m 'Server certificate request being sent to PKI server'
git push

echo -e '\033[92m = = = = and copied to the remote transfer repository = = = = \033[m'
