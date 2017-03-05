#!/bin/bash

TIMESTAMP=`date "+%Y-%m-%dT%H-%M-%S"`
BACKUP_DIR="/backups"
BACKUP_NAME="$TIMESTAMP-influxdb"

mkdir -p $BACKUP_DIR/$BACKUP_NAME

influxd backup -database openhab $BACKUP_DIR/$BACKUP_NAME

tar --remove-files -czf $BACKUP_DIR/$BACKUP_NAME.tar.gz -C $BACKUP_DIR $BACKUP_NAME
