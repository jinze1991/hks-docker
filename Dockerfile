FROM centos:5

	MAINTAINER Kimtaek <jinze1991@icloud.com> <

	RUN DEBIAN_FRONTEND=noninteractive

	RUN yum update -y 
    RUN yum install -y httpd wget make gcc php php-devel php-mbstring php-mcrypt php-mysql 

    # install modules
    RUN mkdir /home/web
    RUN mkdir /home/tmp
    WORKDIR /home/tmp
    
    # install GeoIP
    RUN wget http://www.maxmind.com/download/geoip/api/c/GeoIP-latest.tar.gz
    RUN tar xvfz GeoIP-latest.tar.gz
    RUN GeoIP-1.6.0/configure --prefix=/usr/local/GeoIP
    RUN make && make install
    
    # install GeoIp php
    RUN wget http://pecl.php.net/get/geoip-1.0.8.tgz
    RUN tar xvfz geoip-1.0.8.tgz
    WORKDIR /home/tmp/geoip-1.0.8/
    RUN /usr/bin/phpize
    RUN ./configure --with-php-config=/usr/bin/php-config --with-geoip=/usr/local/GeoIP
    RUN make && make install
    RUN cp modules/geoip.so /usr/lib64/php/modules/
    
    # install php json 1.2.1
    WORKDIR /home/tmp/
    RUN wget https://pecl.php.net/get/json-1.2.1.tgz
    RUN tar xvfz json-1.2.1.tgz
    WORKDIR /home/tmp/json-1.2.1/
    RUN /usr/bin/phpize
    RUN ./configure
    RUN make && make install
    
    # install xdebug 2.1.0
    WORKDIR /home/tmp/
    RUN wget https://xdebug.org/files/xdebug-2.1.0.tgz
    RUN tar xvfz xdebug-2.1.0.tgz
    WORKDIR /home/tmp/xdebug-2.1.0
    RUN /usr/bin/phpize
    RUN ./configure --enable-xdebug --with-php-config=/usr/bin/php-config
    RUN make && make install
    
    # remove tmp dir 
    RUN rm -rf /home/tmp
    
    COPY vhost.conf /etc/httpd/conf.d/vhost.conf
    
	RUN echo "extension=json.so" >> /etc/php.d/json.ini
    RUN echo "zend_extension=/usr/lib64/php/modules/xdebug.so" >> /etc/php.d/xdebug.ini
    RUN echo "xdebug.idekey=1" >> /etc/php.d/xdebug.ini
    RUN echo "xdebug.remote_autostart=1" >> /etc/php.d/xdebug.ini
    RUN echo "xdebug.auto_trace=1" >> /etc/php.d/xdebug.ini
    RUN echo "xdebug.remote_host=localhost" >> /etc/php.d/xdebug.ini
    RUN echo "xdebug.remote_port=9001" >> /etc/php.d/xdebug.ini
    RUN echo "xdebug.remote_enable=1" >> /etc/php.d/xdebug.ini
    RUN echo "xdebug.remote_connect_back = on" >> /etc/php.d/xdebug.ini
    RUN echo "xdebug.remote_log=/var/log/httpd/error_log" >> /etc/php.d/xdebug.ini
    RUN echo "AddType application/x-httpd-php .html .htm" >> /etc/httpd/conf/httpd.conf
	RUN echo "AddDefaultCharset EUC-KR" >> /etc/httpd/conf/httpd.conf
    RUN sed -i '512d' /etc/httpd/conf.d/vhost.conf
    RUN service httpd start
    RUN echo "service httpd start" >> /start.sh
    WORKDIR /home/web/
    
    EXPOSE 80 443 9001
	# Default command
	# CMD ["/bin/bash", "/start.sh"]
