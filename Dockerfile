FROM centos:centos7
MAINTAINER Neogeo Technologies http://www.neogeo-online.net

RUN yum -y update; yum clean all
RUN yum -y install sudo epel-release; yum clean all
RUN yum -y -q reinstall glibc-common; yum clean all
RUN yum install -y pwgen; yum clean all
RUN rpm -Uvh http://yum.postgresql.org/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm
RUN yum -y install postgresql95-server postgresql95; yum clean all

# Install gosu (replacer for sudo) - https://github.com/tianon/gosu
RUN curl -L https://github.com/tianon/gosu/releases/download/1.7/gosu-amd64 -o /usr/local/sbin/gosu; \
   chmod 0755 /usr/local/sbin/gosu
   
ENV DATADIR /data
ENV SUPERUSER neogeo
# ENV SUPERPASS neogeo

# Add scripts
ADD scripts /scripts
RUN chmod +x /scripts/*.sh
RUN touch /.firstrun

VOLUME [${DATADIR}]
EXPOSE 5432

CMD ["/scripts/run.sh"]