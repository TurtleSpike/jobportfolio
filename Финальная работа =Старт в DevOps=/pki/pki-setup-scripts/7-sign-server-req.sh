#!/bin/bash

servername=$1
easydir=`sudo find /home -type d -name easy-rsa`
transfer=/home/$USER/transfer

cd $transfer
git pull origin master

cd $easydir
./easyrsa import-req $transfer/$servername.req $servername

if [ $? -eq 0 ]
then
  echo -e '\033[92m = = = = Server request "'$servername'.req" has been imported = = = = \033[m'
else
  echo -e '\033[91m = = = = Server request "'$servername'.req" has NOT been imported or has already been imported = = = = \033[m'
fi

rm $transfer/$servername.req

./easyrsa sign-req server $servername

if [ $? -eq 0 ]
then
  echo -e '\033[92m = = = = Server request "'$servername'.req" has been signed = = = = \033[m'
else
  echo -e '\033[91m = = = = Server request "'$servername'.req" has NOT been signed = = = = \033[m'
  exit 1
fi

cp $easydir/pki/issued/$servername.crt $transfer
cp $easydir/pki/ca.crt $transfer
git add .
git commit -m "Server certificate $servername being sent to VPN server"
git push

echo -e '\033[92m = = = = and server certificate "'$servername'.crt" has been copied to the remote transfer repository along with "ca.crt" = = = = \033[m'
