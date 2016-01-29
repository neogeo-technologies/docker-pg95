# "ported" by Adam Miller <maxamillion@fedoraproject.org> from
#   https://github.com/fedora-cloud/Fedora-Dockerfiles
#
# Originally written for Fedora-Dockerfiles by
#   scollier <scollier@redhat.com>

FROM centos:centos7
MAINTAINER The CentOS Project <cloud-ops@centos.org>

ENV PGDATA /data
ENV SUPERUSER admin 
ENV SUPERPASS SiHRDZ3Tt13uVVyH0ZST

RUN yum -y update; yum clean all
RUN yum -y install sudo epel-release; yum clean all
RUN rpm -Uvh http://yum.postgresql.org/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm
RUN yum -y install postgresql95-server postgresql95; yum clean all


RUN mkdir $PGDATA
RUN chown postgres $PGDATA
USER postgres
RUN /usr/pgsql-9.5/bin/initdb -D $PGDATA


RUN echo "host    all             all             0.0.0.0/0               md5" >> $PGDATA/pg_hba.conf
RUN echo "local all postgres trust" >> $PGDATA/pg_hba.conf
RUN echo "listen_addresses='*'" >> $PGDATA/postgresql.conf

# fire up db, create superuser, shut down
RUN /usr/pgsql-9.5/bin/pg_ctl -w start && echo create role $SUPERUSER SUPERUSER LOGIN PASSWORD \'$SUPERPASS\' | psql && /usr/pgsql-9.5/bin/pg_ctl -w stop

VOLUME [$PGDATA]

EXPOSE 5432
# listen on network, log to stdout
ENTRYPOINT ["/usr/pgsql-9.5/bin/postgres", "-i", "-c", "logging_collector=off"]
