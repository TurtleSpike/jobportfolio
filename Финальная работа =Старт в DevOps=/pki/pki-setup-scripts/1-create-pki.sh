#!/bin/bash

dir=$1
mkdir -p /home/$USER/got-from-vpn
mkdir -p /home/$USER/send-to-vpn

sudo apt-get update
sudo apt-get install easy-rsa iptables-persistent

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
  echo -e '\033[92m = = = = Directory "easy-rsa" has been created on the \033[4;92m'$PWD'\033[m\033[92m path = = = = \033[m'  
else
  echo -e '\033[91m = = = = Directory "easy-rsa" has NOT been created = = = = \033[m'
  exit 1
fi

ln -s /usr/share/easy-rsa/* $dir/easy-rsa
chown -R $USER $dir/easy-rsa
chmod 700 $dir/easy-rsa

cd $dir/easy-rsa
rsadir=`echo $PWD`
./easyrsa init-pki

if [ $? -eq 0 ]
then
  echo -e '\033[92m = = = = PKI has been initialised = = = = \033[m'
else
  echo -e '\033[91m = = = = PKI has NOT been initialised = = = = \033[m'
  exit 1
fi

cat << FILLVARS > ./pki/vars
set_var EASYRSA_REQ_COUNTRY    "RUS"
set_var EASYRSA_REQ_PROVINCE   "Moscow"
set_var EASYRSA_REQ_CITY       "Moscow City"
set_var EASYRSA_REQ_ORG        "Our Company Name"
set_var EASYRSA_REQ_EMAIL      "sysadmin@company.ru"
set_var EASYRSA_REQ_OU         "LLC"
set_var EASYRSA_ALGO           "ec"
set_var EASYRSA_DIGEST         "sha512"
FILLVARS

sudo rm $rsadir/vars

echo -e '\033[37m !!! USE PASSWORDS OF 5 OR MORE SYMBOLS LONG !!! \033[m'

while true
do
  ./easyrsa build-ca
  status=$?

  if [ $status -ne 0 ]; then
    echo -e '\033[91m = = = = Certificate "ca.crt" has NOT been created = = = = \033[m'
  else
    echo -e '\033[92m = = = = Certificate "ca.crt" has been created on path \033[4;92m'$rsadir'/pki\033[m\033[92m = = = = \033[m'
    break
  fi
done
