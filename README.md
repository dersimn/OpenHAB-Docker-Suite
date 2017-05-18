OpenHAB Docker Suite
====================

This is my `docker-compose` suite for deploying OpenHAB and a few other services on macOS / Mac OS X or however you want to call it.  
We'll use `~/Library/Docker/OpenHAB` to store configuration/persistence related files.

I'm currently not using the PaperUI for configuration, but instead specify everything manually in the according `.items`-, `.things`-, and-so-on- files. The database for any PaperUI configuration is therefore **not** placed inside the `~/Library`.

## Install

Git-clone this repository for e.g. into `~/Applications/Docker`.

Start all containers by executing:

	docker-compose up -d

### Initialize InfluxDB

The current Docker Image for InfluxDB doesn't support automatic creation of users and databases, so create one for OpenHAB manually:

	docker exec -it hma_influxdb influx

Inside the container execute the following queries:

	CREATE DATABASE openhab
	exit

## Update

	docker-compose pull
	docker-compose down
	docker-compose up -d

## Backup

	docker exec -i -t hma_influxdb /bin/bash /backups/backup-influxdb.bash
	docker exec -i -t hma_openhab /bin/bash /backups/backup-openhab.bash
	docker exec -i -t hma_grafana /bin/bash /backups/backup-grafana.bash

### Restore settings from previous Backup

#### InfluxDB

	docker-compose stop
	docker run -it --rm --volumes-from hma_influxdb influxdb /bin/bash
	tar xf /backups/2017-03-05T18-23-52-influxdb.tar.gz -C ~
	influxd restore -metadir /var/lib/influxdb/meta ~/2017-03-05T18-23-52-influxdb
	influxd restore -database openhab -datadir /var/lib/influxdb/data ~/2017-03-05T18-23-52-influxdb
	chown -R influxdb:influxdb /var/lib/influxdb
	exit
	docker-compose start


[1]: https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-16-04
[2]: https://www.digitalocean.com/community/tutorials/how-to-set-up-password-authentication-with-nginx-on-ubuntu-14-04
[3]: https://docs.docker.com/engine/tutorials/dockervolumes/
