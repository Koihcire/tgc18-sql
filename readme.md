mysql -u root

<!-- import the sakila database -->
mysql -u root < sakila-schema.sql
mysql -u root < sakila-data.sql

# import the sakila databases
show databases;

show tables;

# dependencies
npm init
yarn add express
yarn add hbs
yarn add wax-on
yarn add handlebars-helpers
yarn add mysql2
yarn add dotenv

create a init.sh bash file and copy repeated commands
<!-- to give permission to run a shell script -->
chmod +x init.sh 
<!-- to run the bash script / shell script -->
./init.sh


# password
https://www.digitalocean.com/community/tutorials/how-to-create-a-new-user-and-grant-permissions-in-mysql
<!-- normally dont use root user as root user has rights to delete all dbs.
create a new user for each project  -->
CREATE USER 'sammy'@'localhost' IDENTIFIED BY 'password';

<!-- granting permissions -->
GRANT ALL PRIVILEGES ON *.* TO 'sammy'@'localhost' WITH GRANT OPTION;

<!-- to refresh for the privileges to take place immediately, if cannot connect to database -->
FLUSH PRIVILEGES;

# include a env.sample file
for others reading ur repo on github