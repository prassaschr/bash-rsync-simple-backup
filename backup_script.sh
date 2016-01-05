#!/bin/bash
## Christos Prassas - 0.02 - Based on https://bbs.archlinux.org/viewtopic.php?pid=1165598#p1165598
############################################
##
## VARIABLES
# Set source location
BACKUP_FROM="/give/your/source/path/here/"
# Set target location
BACKUP_TO="/give/your/destination/path/here/" #Backup destination
BACKUP_DEV="xxxxxxx-xxxxx-xxxxxxxxxxxxxxx" #UUID of the disk - after a format, check again the UUIDs
BACKUP_MNT="/give_your_mount_point_here"
BACKUP_EXCLUDE_BIN="/.*" #Exclude the hidden files, such as recycle bin or other
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
        echo "$(date "+%Y-%m-%d %k:%M:%S") - ERROR: Unable to sync." >> "$LOG_FILE"
        echo "$(date "+%Y-%m-%d %k:%M:%S") - ERROR: Unable to sync. Check the log file."
        echo "" >> "$LOG_FILE"
        exit 1
fi

# Start entry in the log
echo "$(date "+%Y-%m-%d %k:%M:%S") - Sync started." >> "$LOG_FILE"
echo "$(date "+%Y-%m-%d %k:%M:%S") - Sync started... Please wait."

# Start sync
if rsync -avz --delete --exclude "$BACKUP_EXCLUDE_BIN" "$BACKUP_FROM" "$BACKUP_TO" &>> "$LOG_FILE"; then
        echo "$(date "+%Y-%m-%d %k:%M:%S") - Sync completed succesfully." >> "$LOG_FILE"
        echo "$(date "+%Y-%m-%d %k:%M:%S") - Sync completed succesfully."
else
        echo "$(date "+%Y-%m-%d %k:%M:%S") - ERROR: rsync-command failed." >> "$LOG_FILE"
	echo "$(date "+%Y-%m-%d %k:%M:%S") - ERROR: Unable to sync." >> "$LOG_FILE"
	echo "$(date "+%Y-%m-%d %k:%M:%S") - ERROR: Unable to sync. Check the log file."
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
