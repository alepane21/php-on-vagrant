#!/bin/bash
# 
# Bootstrap script for have a working PHP environment on Vagrant base on ubuntu base box.
# v0.1, 2014-06-09

PROJECTNAME=""
if [ -z "$PROJECTNAME" ]; then
    echo "Devi specificare il nome del progetto!"
    exit 1
fi

if ! [[ $PROJECTNAME =~ ^[0-9a-z\_\-]+$ ]]; then
    echo "Il nome del progetto puo\` essere composto solo da lettere minuscole, numeri, il trattino e l'underscore"
    exit 1
fi

echo "PROJECTNAME=\"$PROJECTNAME\"" | sudo tee -a /etc/environment

export DEBIAN_FRONTEND="noninteractive"

sudo apt-get update
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password mysql'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password mysql'
sudo apt-get -y install mysql-server libapache2-mod-php5 php5-gd php5-curl php5-mcrypt php5-intl php5-mysql
sudo a2enmod rewrite expires headers

echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/app-password-confirm password phpmyadmin' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/admin-pass password mysql' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/app-pass password phpmyadmin' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | sudo debconf-set-selections
sudo apt-get -y install phpmyadmin

to_replace="Required-Start:    \$local_fs \$remote_fs \$network \$syslog \$named"
replace_with="Required-Start:    \$local_fs \$remote_fs \$network \$syslog \$named \$vboxadd-service"
sudo sed -i -e "s/$to_replace/$replace_with/" /etc/init.d/apache2

if ! [ -e /vagrant/logs ]; then
    mkdir /vagrant/logs
fi

read -r -d '' virtualhost <<VHOST
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName $PROJECTNAME.dev
    ServerAlias www.$PROJECTNAME.dev
    DocumentRoot /vagrant/

    <Directory />
        Options FollowSymLinks
        AllowOverride All
    </Directory>

    <Directory /vagrant/>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
    </Directory>

    ErrorLog /vagrant/logs/error.log
    LogLevel warn
    CustomLog /vagrant/logs/access.log combined
</VirtualHost>
VHOST

vhost_file="/etc/apache2/sites-available/$PROJECTNAME"
if ! [ -e $vhost_file ]; then
    echo "$virtualhost" | sudo tee $vhost_file
fi
sudo a2ensite $PROJECTNAME
sudo service apache2 restart
