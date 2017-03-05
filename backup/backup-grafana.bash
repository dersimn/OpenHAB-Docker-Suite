#!/bin/bash

TIMESTAMP=`date "+%Y-%m-%dT%H-%M-%S"`
BACKUP_DIR="/backups"
BACKUP_NAME="$TIMESTAMP-grafana"

mkdir -p $BACKUP_DIR/$BACKUP_NAME

cp -ar /etc/grafana $BACKUP_DIR/$BACKUP_NAME/config
cp -ar /var/lib/grafana $BACKUP_DIR/$BACKUP_NAME/data
cp -ar /var/log/grafana $BACKUP_DIR/$BACKUP_NAME/log

tar --remove-files -czf $BACKUP_DIR/$BACKUP_NAME.tar.gz -C $BACKUP_DIR $BACKUP_NAME