OpenHAB Docker Suite
====================

## Install

Start containers with:

	docker-compose up -d

List containers with

	docker ps

and copy the ID of the InfluxDB container, for e.g. `b66dd2f07b43`, then 'SSH' into it with:

	docker exec -it b66dd2f07b43 /bin/bash

Inside the container execute `influx` and create the InfluxDB database and username using the following queries:

	CREATE USER root WITH PASSWORD 'root' WITH ALL PRIVILEGES
	AUTH root root
	CREATE DATABASE openhab
	CREATE USER openhab WITH PASSWORD 'openhab'
	GRANT ALL ON openhab TO openhab
	exit

## Restore settings from Backup

	docker-compose stop

### InfluxDB

	docker run -it --rm --volumes-from openhab_influxdb_1 -v /Users/simon/Desktop/OpenHAB-Backups:/backups:ro influxdb /bin/bash
	tar xf /backups/openhab-influxdb-2017-02-23T15-17-19.tar.gz -C ~
	influxd restore -metadir /var/lib/influxdb/meta ~/openhab-influxdb-2017-02-23T15-17-19
	influxd restore -database openhab -datadir /var/lib/influxdb/data ~/openhab-influxdb-2017-02-23T15-17-19
	chown -R influxdb:influxdb /var/lib/influxdb
	exit

