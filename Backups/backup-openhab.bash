#!/bin/bash

TIMESTAMP=`date "+%Y-%m-%dT%H-%M-%S"`
BACKUP_DIR="/backups"
BACKUP_NAME="$TIMESTAMP-openhab"

mkdir -p $BACKUP_DIR/$BACKUP_NAME

cp -ar /openhab/conf $BACKUP_DIR/$BACKUP_NAME/config
cp -ar /openhab/userdata $BACKUP_DIR/$BACKUP_NAME/userdata

tar --remove-files -czf $BACKUP_DIR/$BACKUP_NAME.tar.gz -C $BACKUP_DIR $BACKUP_NAME