# Automated System Log Backup Script

A simple yet powerful Bash script for automating system log backups on Linux systems. This script creates compressed archives of essential system logs and can be scheduled to run regularly using cron.

## Features

- Automatically backs up critical system log files
- Creates compressed tar archives with date-stamped filenames
- Sets appropriate permissions on backup files
- Easy to configure and extend
- Designed to be run as a cron job

## Included Log Files

By default, the script backs up the following system logs:
- `/var/log/syslog` - General system logs
- `/var/log/auth.log` - Authentication logs
- `/var/log/dmesg` - Kernel ring buffer logs
- `/var/log/kern.log` - Kernel logs

## Installation

1. Clone this repository or download the script:
   ```bash
   git clone https://github.com/yourusername/log-backup-script.git
   ```

2. Make the script executable:
   ```bash
   chmod +x backup_logs.sh
   ```

3. Modify the backup directory in the script if needed:
   ```bash
   nano backup_logs.sh
   # Edit BACKUP_DIR="/home/labex/project/backup" to your preferred location
   ```

## Usage

### Manual Execution

Run the script manually:

```bash
./backup_logs.sh
```

### Automated Execution with Cron

Set up a cron job to run the script automatically. For example, to run it daily at 2:00 AM:

1. Open your crontab:
   ```bash
   crontab -e
   ```

2. Add the following line:
   ```
   0 2 * * * /path/to/backup_logs.sh >> /path/to/backup/backup.log 2>&1
   ```

This will run the script every day at 2:00 AM and append both standard output and errors to a log file.

## Customization

### Adding More Log Files

To include additional log files in the backup, modify the `tar` command in the script:

```bash
sudo tar -czf $BACKUP_FILE /var/log/syslog /var/log/auth.log /var/log/dmesg /var/log/kern.log /path/to/additional/log 2>/dev/null
```

### Changing Backup Frequency

Modify your cron schedule to change how often backups occur:

- Daily at 2:00 AM: `0 2 * * *`
- Weekly on Sunday at 2:00 AM: `0 2 * * 0`
- Monthly on the 1st at 2:00 AM: `0 2 1 * *`

### Backup Rotation

For implementing a backup rotation policy (to prevent filling up disk space), consider adding code to remove older backups:

```bash
# Remove backups older than 30 days
find $BACKUP_DIR -name "logs_backup_*.tar.gz" -mtime +30 -delete
```

Add this line to the script before the final echo command.

## File Permissions

The script sets the following permissions on backup files:
- Owner: labex (change this to your username)
- Group: labex (change this to your group)
- Permissions: 644 (rw-r--r--)

## Requirements

- Linux system with bash shell
- sudo privileges (for reading protected log files)
- tar command (standard on most Linux distributions)
