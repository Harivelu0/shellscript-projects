#!/bin/bash

# Create backup directory if it doesn't exist
BACKUP_DIR="/home/labex/project/backup"
mkdir -p $BACKUP_DIR

# Get current date in YYYY-MM-DD format
DATE=$(date +%Y-%m-%d)

# Create the backup filename with date
BACKUP_FILE="$BACKUP_DIR/logs_backup_$DATE.tar.gz"

# Create a tar archive of the log files
# Using sudo in case we need elevated permissions to read log files
sudo tar -czf $BACKUP_FILE /var/log/syslog /var/log/auth.log /var/log/dmesg /var/log/kern.log 2>/dev/null

# Set proper permissions for the backup file
sudo chown labex:labex $BACKUP_FILE
chmod 644 $BACKUP_FILE

# Print success message
echo "Log backup created: $BACKUP_FILE"

#crontab command 0 2 * * * /home/labex/project/backup_logs.sh >> /home/labex/project/backup/backup.log 2>&1