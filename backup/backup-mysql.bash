#!/bin/bash

TIMESTAMP=`date "+%Y-%m-%dT%H-%M-%S"`
BACKUP_DIR="/backups"
BACKUP_NAME="$TIMESTAMP-mysql"

mysqldump -u openhab -popenhab openhab | gzip > $BACKUP_DIR/$BACKUP_NAME.sql.gz
