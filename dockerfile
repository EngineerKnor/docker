#? Start from the official Ubuntu image
FROM ubuntu:latest
#? Prevent dpkg errors
ENV DEBIAN_FRONTEND=noninteractive

#? Set your timezone here
ENV TZ=UTC

#? Update the system and install required packages
RUN apt-get update && apt-get install -y wget lsb-release gnupg jq

#? Install MySQL 8
RUN apt-get update && apt-get install -y mysql-server

#? Install necessary software for phpMyAdmin
RUN apt-get install -y php php-mysql php-xml php-mbstring php-zip php-gd php-json apache2 libapache2-mod-php unzip

#? Download and setup phpMyAdmin
RUN wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip -O phpmyadmin.zip
RUN unzip phpmyadmin.zip && mv phpMyAdmin-*-all-languages /var/www/html/phpmyadmin

#? Copy some necessary files to the docker container
COPY ["mysqld.cnf", "/etc/mysql/mysql.conf.d/mysqld.cnf"]
COPY ["config.inc.php", "/var/www/html/phpmyadmin/config.inc.php"]
RUN chown -R www-data:www-data /var/www/html/phpmyadmin

#? Fix '/nonexistent' bug - https://github.com/miguelgrinberg/microblog/issues/256
RUN /etc/init.d/mysql stop 
RUN usermod -d /var/lib/mysql/ mysql 

#? Create the database based on the files from cs-db-setup
RUN /etc/init.d/mysql start && \
    mysql -e "CREATE USER 'user'@'%' IDENTIFIED WITH 'mysql_native_password' BY 'password'" && \
    mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'user'@'%';" && \
    mysql -e "FLUSH PRIVILEGES;" && \
    mysql -e "CREATE DATABASE database CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;" 
    # && \
    # for file in `ls Setup/*.sql`; do mysql < $file; done #? This line creates the database based on files from a folder.
    # jq '.main | .[]' /usr/app/setup-project/scripts/scripts-by-type.json | \
    # while read i; do mysql --default-character-set=utf8mb4 project_db < `ls $(echo "/usr/app/setup-project/scripts/${i}" | tr -d '"')`; done && \
    # mysql --default-character-set=utf8mb4 project_db < /usr/app/setup-project/scripts/script.sql && \

# TODO: Load timezone info in the database
# https://stackoverflow.com/questions/14454304/convert-tz-returns-null

#? Expose MySQL and phpMyAdmin ports
EXPOSE 3306
EXPOSE 80

#? Start services
CMD /etc/init.d/mysql start && apache2ctl -D FOREGROUND
