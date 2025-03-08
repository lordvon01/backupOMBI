#!/bin/bash

# Information
# Script Name: Ombi Backup Script
# Description: This script creates backups of the Ombi database and configuration files.
# Author: [Your Name]
# Date: March 8, 2025
# Version: 1.0

# Configuration
OMBI_PATH="/etc/Ombi"  # Path where Ombi is installed
BACKUP_PATH="/mnt/Public/OMBI\ backups"  # Path where backups will be stored
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
DB_BACKUP_NAME="OmbiDatabase_$TIMESTAMP.db"
CONFIG_BACKUP_NAME="OmbiConfig_$TIMESTAMP.tar.gz"
LOG_FILE="$BACKUP_PATH/backup_log_$TIMESTAMP.txt"

# Functions
log_message() {
    echo "$1" | tee -a "$LOG_FILE"
}

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_PATH"

# Backup database
log_message "Starting database backup..."
if cp "$OMBI_PATH/Ombi.db" "$BACKUP_PATH/$DB_BACKUP_NAME"; then
    log_message "Database backup successful: $BACKUP_PATH/$DB_BACKUP_NAME"
else
    log_message "Database backup failed!"
    exit 1
fi

# Backup configuration files
log_message "Starting configuration backup..."
if tar -czf "$BACKUP_PATH/$CONFIG_BACKUP_NAME" -C "$OMBI_PATH" . --exclude='Ombi.db'; then
    log_message "Configuration backup successful: $BACKUP_PATH/$CONFIG_BACKUP_NAME"
else
    log_message "Configuration backup failed!"
    exit 1
fi

log_message "Backup completed successfully."

# Optionally, you can clean up old backups. For example, remove backups older than 30 days:
find "$BACKUP_PATH" -name 'OmbiDatabase_*.db' -mtime +30 -exec rm {} \;
find "$BACKUP_PATH" -name 'OmbiConfig_*.tar.gz' -mtime +30 -exec rm {} \;

log_message "Old backups cleaned up."

exit 0
