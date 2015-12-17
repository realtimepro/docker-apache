FROM babim/ubuntubase

MAINTAINER "Duc Anh Babim" <ducanh.babim@yahoo.com>

RUN apt-get clean && \
    apt-get update && \
    apt-get install software-properties-common -y && \
    add-apt-repository ppa:ondrej/php5-5.6 -y && \
    apt-get update && \
    apt-get dist-upgrade -y --force-yes && \
    apt-get install openssh-server apache2 php5 php5-json php5-gd php5-sqlite curl php5-curl php-xml-parser php5-ldap php5-mysql php5-pgsql php5-imap php5-tidy php5-xmlrpc php5-mcrypt php5-memcache php-apc php5-intl ImageMagick -y --force-yes && \
    apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove && \
    a2enmod rewrite && \
    a2enmod headers

RUN sed -ri 's/^display_errors\s*=\s*Off/display_errors = On/g' /etc/php5/apache2/php.ini
RUN sed -ri 's/^display_errors\s*=\s*Off/display_errors = On/g' /etc/php5/cli/php.ini

RUN mkdir /var/run/sshd
# set password root 123456
RUN echo 'root:123456' | chpasswd
# allow root ssh
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

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

EXPOSE 80 22
ADD start.sh /start.sh
RUN chmod 0755 /start.sh
CMD ["bash", "start.sh", "/usr/sbin/sshd", "-D"
