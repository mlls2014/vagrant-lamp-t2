#!/usr/bin/env bash

# Variables
MYSQL_PASS=root

# Modifica teclado y locale a ES
apt-get update
apt-get install -y locales  # install locales support
echo 'es_ES.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen  # enable locales in `/etc/locale.gen`
update-locale LANG=es_ES.UTF-8  # setup default VM locale
#Configurar teclado español
echo "Configurando teclado"
sed -ie '/^XKBLAYOUT=/s/".*"/"es"/' /etc/default/keyboard && udevadm trigger --subsystem-match=input --action=change
dpkg-reconfigure --frontend=noninteractive keyboard-configuration  
setupcon

timedatectl set-timezone Europe/Madrid

#Instalamos Apache
apt-get install -y apache2 apache2-utils

#Instalamos MariaDB
apt-get install -y mariadb-server mariadb-client

#Para personalizar la configuración de MariaDB
cp /vagrant/.provision/50-server.cnf /etc/mysql/mariadb.conf.d

#Instalar php

apt-get install -y php libapache2-mod-php 
apt-get install -y php7.4-{bcmath,bz2,common,json,opcache,readline,intl,gd,mbstring,mysql,pdo,zip,xdebug,xml,imagick,tokenizer,intl,curl} 

a2enmod expires
a2enmod headers
a2enmod rewrite

#Activar uso módulo php7.4-fpm
#apt-get install -y php7.4-fpm
#a2enmod proxy_fcgi setenvif
#a2enconf php7.4-fpm

#Para personalizar la configuración de sitio por defecto en Apache
cp /vagrant/.provision/000-default.conf /etc/apache2/sites-enabled

#Instalar composer, git, curl

apt-get install -y composer git curl

#Instalar npm

apt-get install -y npm build-essential

#Habilitar depuración remota
cp /vagrant/.provision/xdebug.ini /etc/php/7.4/mods-available

# Configuring xDebug (idekey = ) --"
tee -a /etc/php/7.4/apache2/php.ini << END
[XDebug]
xdebug.remote_enable = 1
xdebug.remote_autostart = 1
END

# Cambiando document root. El directorio document root ./source
if [ ! -L /var/www/html ]; then
    if [ ! -d /vagrant/source ]; then
        sudo mkdir -p /vagrant/source
    fi
    sudo rm -rf /var/www/html
    sudo ln -fs /vagrant/source /var/www/html
    sudo chmod 755 /var/www/html
fi


systemctl restart apache2
systemctl restart mysql