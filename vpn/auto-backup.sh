#!/bin/bash

backupname=vpn-backup-`date '+%Y-%m-%d'`

mkdir -p /backup && sudo chown -R $USER:$USER /backup
cd /backup

git pull origin master

find /backup -type f -mtime +7 -delete
sudo tar -zcvpf /backup/$backupname.tar.gz --exclude=/proc --exclude=/sys --exclude=/mnt --exclude=/media --exclude=/run --exclude=/dev --exclude=/backup --warning=no-file-changed /

git add .
git commit -m "$backupname"
git push