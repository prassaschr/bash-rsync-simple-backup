#!/bin/bash
## Christos Prassas - 0.01 - Based on https://bbs.archlinux.org/viewtopic.php?pid=1165598#p1165598
## This script must run once each month and copy the daily backup to monthly backup, zipped, tar
############################################
##
## VARIABLES
# Set source location
BACKUP_FROM="/home/rsync/daily/"
# Set target location
BACKUP_TO="/home/mark/rsync/monthly/monthly_$(date +%Y%m%d).tar.bz2" #Backup destination
BACKUP_DEV="xxxxxxx-xxxxx-xxxxxxxxxxxxxxx" #UUID of the disk - after a format, check again the UUIDs
BACKUP_MNT="/give_your_mount_point_here"
# Log file
LOG_FILE="/var/log/backup_script.log"
###########################################
##
## SCRIPT
##

# Check that the log file exists
if [ ! -e "$LOG_FILE" ]; then
        touch "$LOG_FILE"
fi

# Check that source dir exists and is readable.
if [ ! -r  "$BACKUP_FROM" ]; then
        echo "$(date "+%Y-%m-%d %k:%M:%S") - ERROR: Unable to read source dir." >> "$LOG_FILE"
	echo "$(date "+%Y-%m-%d %k:%M:%S") - ERROR: Unable to read source dir."
        echo "$(date "+%Y-%m-%d %k:%M:%S") - ERROR: Unable to sync." >> "$LOG_FILE"
        echo "$(date "+%Y-%m-%d %k:%M:%S") - ERROR: Unable to sync. Check the log file..."
        echo "" >> "$LOG_FILE"
        exit 1
fi

# Check if the drive is mounted
if ! mountpoint "$BACKUP_MNT"; then
        echo "$(date "+%Y-%m-%d %k:%M:%S") - WARNING: Backup device needs mounting!" >> "$LOG_FILE"
        echo "$(date "+%Y-%m-%d %k:%M:%S") - WARNING: Backup device needs mounting!"
	echo "$(date "+%Y-%m-%d %k:%M:%S") - Mounting the HDD... Please wait."

        # If not, mount the drive
        if mount -U "$BACKUP_DEV" "$BACKUP_MNT"; then
                echo "$(date "+%Y-%m-%d %k:%M:%S") - Backup device mounted." >> "$LOG_FILE"
		echo "$(date "+%Y-%m-%d %k:%M:%S") - HDD mounted successfully!"
        else
                echo "$(date "+%Y-%m-%d %k:%M:%S") - ERROR: Unable to mount backup device." >> "$LOG_FILE"
                echo "$(date "+%Y-%m-%d %k:%M:%S") - ERROR: Unable to mount backup device."
                echo "$(date "+%Y-%m-%d %k:%M:%S") - ERROR: Unable to sync." >> "$LOG_FILE"
                echo "$(date "+%Y-%m-%d %k:%M:%S") - ERROR: Unable to sync. Check the log file."
                echo "" >> "$LOG_FILE"
                exit 1
        fi
fi

# Check that target dir exists and is writable.
if [ ! -w  "$BACKUP_TO" ]; then
        echo "$(date "+%Y-%m-%d %k:%M:%S") - ERROR: Unable to write to target dir." >> "$LOG_FILE"
        echo "$(date "+%Y-%m-%d %k:%M:%S") - ERROR: Unable to write to target dir."
        echo "$(date "+%Y-%m-%d %k:%M:%S") - ERROR: Unable to tar." >> "$LOG_FILE"
        echo "$(date "+%Y-%m-%d %k:%M:%S") - ERROR: Unable to tar. Check the log file."
        echo "" >> "$LOG_FILE"
        exit 1
fi

# Start entry in the log
echo "$(date "+%Y-%m-%d %k:%M:%S") - Sync started." >> "$LOG_FILE"
echo "$(date "+%Y-%m-%d %k:%M:%S") - Sync started... Please wait."

# Start sync
if tar -cvjf "$BACKUP_TO" "$BACKUP_FROM" &>> "$LOG_FILE"; then
        echo "$(date "+%Y-%m-%d %k:%M:%S") - Monthly tar completed succesfully." >> "$LOG_FILE"
        echo "$(date "+%Y-%m-%d %k:%M:%S") - Monthly tar completed succesfully."
else
        echo "$(date "+%Y-%m-%d %k:%M:%S") - ERROR: tar-command failed." >> "$LOG_FILE"
	echo "$(date "+%Y-%m-%d %k:%M:%S") - ERROR: Unable to tar." >> "$LOG_FILE"
	echo "$(date "+%Y-%m-%d %k:%M:%S") - ERROR: Unable to tar. Check the log file."
	echo "" >> "$LOG_FILE"
	exit 1
fi

# Unmount the drive so it does not accidentally get damaged or wiped
if umount "$BACKUP_MNT"; then
	echo "$(date "+%Y-%m-%d %k:%M:%S") - Backup device unmounted." >> "$LOG_FILE"
	echo "$(date "+%Y-%m-%d %k:%M:%S") - Backup device unmounted... Bye."
else
	echo "$(date "+%Y-%m-%d %k:%M:%S") - WARNING: Backup device could not be unmounted." >> "$LOG_FILE"
	echo "$(date "+%Y-%m-%d %k:%M:%S") - WARNING: Backup device could not be unmounted."
fi
# echo "This is the body" | mail -s "Subject" -aFrom:Harry\<harry@gmail.com\> someone@example.com
# End entry in the log
echo "" >> "$LOG_FILE"
exit 0
