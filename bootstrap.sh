# The output of all these installation steps is noisy. With this utility
# the progress report is nice and concise.
function install {
    echo installing $1
    shift
    apt-get -y install "$@" >/dev/null 2>&1
}

# Mongo installation 
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
sudo apt-get update
install mongodb-org=3.0.12 mongodb-org-server=3.0.12 mongodb-org-shell=3.0.12 mongodb-org-mongos=3.0.12 mongodb-org-tools=3.0.12

echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-org-shell hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections

sudo service mongod start
# end Mongo


install 'development tools' build-essential

# install Ruby ruby2.3 ruby2.3-dev
# update-alternatives --set ruby /usr/bin/ruby2.3 >/dev/null 2>&1
# update-alternatives --set gem /usr/bin/gem2.3 >/dev/null 2>&1

# echo installing Bundler
# gem install bundler -N >/dev/null 2>&1

install Git git
install	Curl curl
install libssl libssl-dev
install SQLite sqlite3 libsqlite3-dev
install memcached memcached
install Redis redis-server

install RabbitMQ rabbitmq-server

install PostgreSQL postgresql postgresql-contrib libpq-dev
sudo -u postgres createuser --superuser vagrant
sudo -u postgres createdb -O vagrant activerecord_unittest
sudo -u postgres createdb -O vagrant activerecord_unittest2

debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
install MySQL mysql-server libmysqlclient-dev
mysql -uroot -proot <<SQL
CREATE USER 'rails'@'localhost';
CREATE DATABASE activerecord_unittest  DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE DATABASE activerecord_unittest2 DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON activerecord_unittest.* to 'rails'@'localhost';
GRANT ALL PRIVILEGES ON activerecord_unittest2.* to 'rails'@'localhost';
GRANT ALL PRIVILEGES ON inexistent_activerecord_unittest.* to 'rails'@'localhost';
SQL

install 'Nokogiri dependencies' libxml2 libxml2-dev libxslt1-dev
install 'Blade dependencies' libncurses5-dev
# install 'ExecJS runtime' nodejs

# rvm and ruby
su - vagrant -c 'curl -sSL https://get.rvm.io | bash -s stable --ruby'
su - vagrant -c 'rvm rvmrc warning ignore allGemfiles'

# node
su - vagrant -c 'curl https://raw.githubusercontent.com/creationix/nvm/v0.14.0/install.sh | sh'
su - vagrant -c 'nvm install node'
su - vagrant -c 'nvm alias default node'

# Needed for docs generation.
update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

echo 'all set, rock on!'
