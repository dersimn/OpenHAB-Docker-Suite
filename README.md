OpenHAB Docker Suite
====================

This is my `docker-compose` suite for deploying OpenHAB and a few other services on macOS / Mac OS X or however you want to call it.  
We'll use `~/Library/Docker/OpenHAB` to store configuration/persistence related files.

I'm currently not using the PaperUI for configuration, but instead specify everything manually in the according `.items`-, `.things`-, and-so-on- files. The database for any PaperUI configuration is therefore **not** placed inside the `~/Library`, but still persisted inside of a [named docker volume][3].

## Install

Git-clone this repository for e.g. into `~/Applications/Docker`.

Before starting your containers **create at least one htpasswd user** by executing the two commands for each user (create the directory first: `mkdir -p ~/Library/Docker/OpenHAB/Nginx`)

	echo -n 'user01:' >> ~/Library/Docker/OpenHAB/Nginx/htpasswd
	openssl passwd -apr1 >> ~/Library/Docker/OpenHAB/Nginx/htpasswd

**and one SSL certificate**: 

	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ~/Library/Docker/OpenHAB/Nginx/nginx-ssl.key -out ~/Library/Docker/OpenHAB/Nginx/nginx-ssl.crt

Then start all containers by executing:

	docker-compose up -d

### Initialize InfluxDB

The current Docker Image for InfluxDB doesn't support automatic creation of users and databases, so create one for OpenHAB manually:

List containers with

	docker ps

and copy the ID of the InfluxDB container, for e.g. `b66dd2f07b43`, then 'SSH' into it with:

	docker exec -it b66dd2f07b43 influx

Inside the container execute the following queries:

	CREATE USER root WITH PASSWORD 'root' WITH ALL PRIVILEGES
	AUTH root root
	CREATE DATABASE openhab
	CREATE USER openhab WITH PASSWORD 'openhab'
	GRANT ALL ON openhab TO openhab
	exit

## Update

	docker-compose pull
	docker-compose down
	docker-compose up -d

## Backup

	docker exec -i -t openhab_influxdb_1 /bin/bash /backups/backup-influxdb.bash
	docker exec -i -t openhab_openhab_1 /bin/bash /backups/backup-openhab.bash
	docker exec -i -t openhab_grafana_1 /bin/bash /backups/backup-grafana.bash

### Restore settings from previous Backup

#### InfluxDB

	docker-compose stop
	docker run -it --rm --volumes-from openhab_influxdb_1 influxdb /bin/bash
	tar xf /backups/2017-03-05T18-23-52-influxdb.tar.gz -C ~
	influxd restore -metadir /var/lib/influxdb/meta ~/2017-03-05T18-23-52-influxdb
	influxd restore -database openhab -datadir /var/lib/influxdb/data ~/2017-03-05T18-23-52-influxdb
	chown -R influxdb:influxdb /var/lib/influxdb
	exit
	docker-compose start


[1]: https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-16-04
[2]: https://www.digitalocean.com/community/tutorials/how-to-set-up-password-authentication-with-nginx-on-ubuntu-14-04
[3]: https://docs.docker.com/engine/tutorials/dockervolumes/
