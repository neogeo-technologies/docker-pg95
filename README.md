# docker-pg95
Simple PostgreSQL 9.5 server image (based on Centos 7)

This image uses the fr_FR.UTF-8 locale.


## Volumes declared:
- $DATADIR: db data dir path

## Environment variables
- DATADIR (default value: /data): PostgreSQL data dir
- SUPERUSER (default value: neogeo): PostgreSQL superuser login
- SUPERUSER (default value: none): PostgreSQL superuser password. If this variable is not defined in your docker run command or in your docker-compose file, it will be generated randomly. To get its value, use docker logs or docker-compose logs.


## Credits
Originally written for Fedora-Dockerfiles by scollier <scollier@redhat.com>

Ported by Adam Miller <maxamillion@fedoraproject.org> from https://github.com/fedora-cloud/Fedora-Dockerfiles

Adapted by Guillaume Sueur and Benjamin Chartier http://www.neogeo-online.net

Inspiration for parts of the run.sh script:
- https://github.com/tutumcloud/postgresql
- https://github.com/frodenas/docker-postgresql
- https://github.com/Painted-Fox/docker-postgresql


## Using the image
see the docker-compose configuration file in the resource dir