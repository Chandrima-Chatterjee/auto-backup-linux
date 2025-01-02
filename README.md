# Auto-Backup Linux Project

## Overview

This project automates file backups from one Linux system (VM1) to another (VM2) using `rsync` over SSH and scheduling backups with `cron`. It is designed to provide a simple yet effective solution for regular, automated backups between two Linux VMs.

### Features
- **Automated Backups**: Using `cron` to schedule backups.
- **Efficient File Transfer**: `rsync` ensures that only new or changed files are copied, making the process faster.
- **Secure Transfers**: Uses SSH for encrypted file transfers between systems.
- **Logging**: Keeps a log of backup activities.

## Technologies Used

- **rsync**: A fast and versatile file copy tool.
- **cron**: A time-based job scheduler in Linux.
- **SSH**: Secure communication between two Linux systems.
- **Bash scripting**: Automating the backup process using shell scripts.

## Setup Instructions

### Prerequisites
- Two Linux VMs (VM1 and VM2).
- SSH access between both VMs (passwordless SSH for automation).
- rsync and cron installed on both systems.

### Steps

1. **Install rsync and SSH on both VMs**:
   - On VM1 (Source-System):
     ```bash
     sudo apt install rsync openssh-client
     ```
   - On VM2 (Backup-Server):
     ```bash
     sudo apt install rsync openssh-server
     ```

2. **Generate SSH Key Pair for Passwordless Authentication**:
   - On VM1 (Source-System), generate an SSH key pair:
     ```bash
     ssh-keygen -t rsa -b 2048
     ```
   - Copy the public key to VM2 (Backup-Server):
     ```bash
     ssh-copy-id root@192.168.0.18
     ```

3. **Create Backup Directory on VM2**:
   - On VM2 (Backup-Server):
     ```bash
     mkdir -p /home/root/backups
     chmod 700 /home/root/backups
     ```

4. **Create the Backup Script on VM1**:
   - On VM1, create the backup script (`/home/chandrima/backup.sh`):
     ```bash
     #!/bin/bash
     SOURCE_DIR="/home/chandrima/data/"
      BACKUP_USER="root"
      BACKUP_SERVER="192.168.0.18"
      BACKUP_DIR="/home/root/backups/$(date +%F)"
      
      # Ensure the destination directory exists
      ssh ${BACKUP_USER}@${BACKUP_SERVER} "mkdir -p ${BACKUP_DIR}"
      
      # Perform the rsync backup
      rsync -avz --delete ${SOURCE_DIR} ${BACKUP_USER}@${BACKUP_SERVER}:${BACKUP_DIR}
      
      echo "Backup completed on $(date)" >> /home/chandrima/backup.log

     ```

5. **Automate Backups Using Cron**:
   - On VM1, open the crontab editor:
     ```bash
     crontab -e
     ```
   - Add the following line to schedule daily backups at 2 AM:
     ```bash
     0 2 * * * /home/chandrima/backup.sh
     ```

### Running the Backup

To manually trigger the backup, run:
```bash
bash /home/chandrima/backup.sh

