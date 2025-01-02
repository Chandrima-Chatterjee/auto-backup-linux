#!/bin/bash

# Define source and destination
SOURCE_DIR="/home/chandrima/data/"
BACKUP_USER="root"
BACKUP_SERVER="192.168.0.18"
BACKUP_DIR="/home/root/backups/$(date +%F)"

# Ensure the destination directory exists
ssh ${BACKUP_USER}@${BACKUP_SERVER} "mkdir -p ${BACKUP_DIR}"

# Perform the rsync backup
rsync -avz --delete ${SOURCE_DIR} ${BACKUP_USER}@${BACKUP_SERVER}:${BACKUP_DIR}

echo "Backup completed on $(date)" >> /home/chandrima/backup.log
