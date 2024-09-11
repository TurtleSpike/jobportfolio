#!/bin/bash

dir=$1
sudo apt-get update
sudo apt-get install openvpn easy-rsa

if [ $? -eq 0 ]
then
  echo -e '\033[92m = = = = Packages have been installed = = = = \033[0m'
else
  echo -e '\033[91m = = = = Packages have NOT been installed = = = = \033[m'
  exit 1
fi

mkdir -p $dir/easy-rsa

if [ $? -eq 0 ]
then
  echo -e '\033[92m = = = = Directory "easy-rsa" has been created on path \033[4;92m'$PWD'\033[m\033[92m = = = = \033[m'  
else
  echo -e '\033[91m = = = = Directory "easy-rsa" has NOT been created = = = = \033[m'
  exit 1
fi

rsadir=`sudo find /home -type d -name easy-rsa`
ln -s /usr/share/easy-rsa/* $rsadir
chown -R $USER:$USER $rsadir
chmod 700 $rsadir

cd $rsadir
./easyrsa init-pki

if [ $? -eq 0 ]
then
  echo -e '\033[92m = = = = PKI has been initialised = = = = \033[m'
else
  echo -e '\033[91m = = = = PKI has NOT been initialised = = = = \033[m'
  exit 1
fi

cat << FILLVARS > ./pki/vars
set_var EASYRSA_ALGO           "ec"
set_var EASYRSA_DIGEST         "sha512"
FILLVARS
