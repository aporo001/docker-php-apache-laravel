FROM eboraas/apache:jessie
MAINTAINER Ed Boraas <ed@boraas.ca>

#RUN apt-get install wget
#RUN echo "deb http://packages.dotdeb.org wheezy-php56 all" | tee -a /etc/apt/sources.list && echo "deb-src http://packages.dotdeb.org wheezy-php56 all" | tee -a /etc/apt/sources.list
#RUN wget -q http://www.dotdeb.org/dotdeb.gpg -O - | apt-key add -
RUN apt-get update && apt-get -y install php5 git curl php5-mcrypt php5-json && apt-get -y autoremove && apt-get clean
RUN apt-get update && apt-get -y install php5-mysql && apt-get clean 
RUN apt-get update 
RUN apt-get -y install memcached php5-memcache 
RUN apt-get -y install php5-redis
#RUN apt-get -y install php-horde-elasticsearch
RUN apt-get -y install php5-mongo
RUN apt-get -y install php5-solr
RUN apt-get clean 


RUN /usr/sbin/a2enmod rewrite

# This is no longer available by default in jessie's apache2
RUN /usr/sbin/a2enmod socache_shmcb || true

# Note: "default" is enabled in the default installation, and "default-ssl" is enabled in the eboraas/apache image, so no need to recreate the symlinks here, just copy the new site definitions into place
#ADD default /etc/apache2/sites-available/
#ADD default-ssl /etc/apache2/sites-available/

ADD laravel.app.conf /etc/apache2/sites-available/laravel.app.conf

RUN ln -s /etc/apache2/sites-available/laravel.app.conf /etc/apache2/sites-enabled/laravel.app.conf

#RUN /usr/bin/curl -sS https://getcomposer.org/installer |/usr/bin/php
#RUN /bin/mv composer.phar /usr/local/bin/composer
#RUN /usr/local/bin/composer create-project laravel/laravel /var/www/laravel --prefer-dist
#RUN /bin/chown www-data:www-data -R /var/www/laravel/storage

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
