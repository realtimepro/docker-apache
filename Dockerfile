FROM babim/debianbase:ssh

MAINTAINER "Duc Anh Babim" <ducanh.babim@yahoo.com>

RUN apt-get clean && \
    apt-get update && \
    echo 'deb http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list.d/dotweb.list && \
    echo 'deb-src http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list.d/dotweb.list && \
    wget http://www.dotdeb.org/dotdeb.gpg -O- |apt-key add – && \
    apt-get update && \
    apt-get install apache2 php5 php5-json php5-gd php5-sqlite curl php5-curl php-xml-parser php5-ldap php5-mysql php5-pgsql php5-imap php5-tidy php5-xmlrpc php5-mcrypt php5-memcache php-apc php5-intl ImageMagick -y --force-yes && \
    apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove && \
    a2enmod rewrite && \
    a2enmod headers

# Set Apache environment variables (can be changed on docker run with -e)
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_SERVERADMIN admin@localhost
ENV APACHE_SERVERNAME localhost
ENV APACHE_SERVERALIAS docker.localhost
ENV APACHE_DOCUMENTROOT /var/www
ENV LC_ALL C.UTF-8

EXPOSE 80 22
ADD start.sh /start.sh
RUN chmod 0755 /start.sh
CMD ["bash", "start.sh", "/usr/sbin/sshd", "-D"
