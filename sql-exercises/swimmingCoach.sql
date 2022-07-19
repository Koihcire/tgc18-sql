-- create database
create database swimming_coach2;

-- switch to active database
use swimming_coach2;

-- CREATE PARENTS TABLE
create table parents(
    parent_id int unsigned auto_increment primary key,
    name varchar(100) not null,
    contact_no varchar(10) not null,
    occupation varchar(100)
) engine = innodb;
+------------+--------------+------+-----+---------+----------------+
| Field      | Type         | Null | Key | Default | Extra          |
+------------+--------------+------+-----+---------+----------------+
| parent_id  | int unsigned | NO   | PRI | NULL    | auto_increment |
| name       | varchar(100) | NO   |     | NULL    |                |
| contact_no | varchar(10)  | NO   |     | NULL    |                |
| occupation | varchar(100) | YES  |     | NULL    |                |
+------------+--------------+------+-----+---------+----------------+
-- insert new entry
insert into parents (name, contact_no, occupation)
    values ("Tan Ah Lian","9999999", "Truck Driver");

insert into parents (name, contact_no, occupation) values
    ("Mary Sue", "1111111", "Doctor"),
    ("Tan Ah Kow", "2222222", "Programmer");


-- CREATE LOCATIONS TABLE
create table locations (
    location_id mediumint unsigned auto_increment primary key,
    name varchar(100) not null,
    address varchar(255) not null
) engine = innodb;
+-------------+--------------+------+-----+---------+----------------+
| Field       | Type         | Null | Key | Default | Extra          |
+-------------+--------------+------+-----+---------+----------------+
| location_id | mediumint unsigned | NO   | PRI | NULL    | auto_increment |
| name        | varchar(100) | NO   |     | NULL    |                |
| address     | varchar(255) | NO   |     | NULL    |                |
+-------------+--------------+------+-----+---------+----------------+
-- insert locations
insert into locations (name, address)
    values("Yishun Swimming Complex", "Yishun Ave 4");

-- CREATE ADDRESSES TABLE
-- create table with fk column first before setting it as fk
create table addresses (
    address_id int unsigned auto_increment primary key,
    parent_id int unsigned not null,
    block_number varchar(6) not null,
    street_name varchar(255) not null,
    unit_number varchar(100) not null,
    postal_code varchar(10) not null
) engine = innodb;
+--------------+--------------+------+-----+---------+----------------+
| Field        | Type         | Null | Key | Default | Extra          |
+--------------+--------------+------+-----+---------+----------------+
| address_id   | int unsigned | NO   | PRI | NULL    | auto_increment |
| parent_id    | int unsigned | NO   |     | NULL    |                |
| block_number | varchar(6)   | NO   |     | NULL    |                |
| street_name  | varchar(255) | NO   |     | NULL    |                |
| unit_number  | varchar(100) | NO   |     | NULL    |                |
| postal_code  | varchar(10)  | NO   |     | NULL    |                |
+--------------+--------------+------+-----+---------+----------------+
-- add parent_id foreign key to addresses table
alter table addresses add constraint fk_addresses_parents
    foreign key (parent_id) references parents(parent_id);
+--------------+--------------+------+-----+---------+----------------+
| Field        | Type         | Null | Key | Default | Extra          |
+--------------+--------------+------+-----+---------+----------------+
| address_id   | int unsigned | NO   | PRI | NULL    | auto_increment |
| parent_id    | int unsigned | NO   | MUL | NULL    |                |
| block_number | varchar(6)   | NO   |     | NULL    |                |
| street_name  | varchar(255) | NO   |     | NULL    |                |
| unit_number  | varchar(100) | NO   |     | NULL    |                |
| postal_code  | varchar(10)  | NO   |     | NULL    |                |
+--------------+--------------+------+-----+---------+----------------+


-- CREATE STUDENTS TABLE
-- create table and fk together in one step, sql will auto create the constraint name
create table students (
    student_id int unsigned auto_increment primary key,
    parent_id int unsigned not null,
    name varchar(100) not null,
    date_of_birth date not null,
    foreign key (parent_id) references parents(parent_id)
) engine = innodb;
+---------------+--------------+------+-----+---------+----------------+
| Field         | Type         | Null | Key | Default | Extra          |
+---------------+--------------+------+-----+---------+----------------+
| student_id    | int unsigned | NO   | PRI | NULL    | auto_increment |
| parent_id     | int unsigned | NO   | MUL | NULL    |                |
| name          | varchar(100) | NO   |     | NULL    |                |
| date_of_birth | date         | NO   |     | NULL    |                |
+---------------+--------------+------+-----+---------+----------------+
-- insert student
insert into students (name, date_of_birth, parent_id) values 
    ("Cindy Tan", "2020-5-21", 2);
-- parent id 2 is Mary Sue
+------------+-----------+-----------+---------------+
| student_id | parent_id | name      | date_of_birth |
+------------+-----------+-----------+---------------+
|          2 |         2 | Cindy Tan | 2020-05-21    |
+------------+-----------+-----------+---------------+

-- CREATE SESSIONS TABLE
create table sessions(
    session_id int unsigned auto_increment primary key,
    date_time datetime not null,
    location_id mediumint unsigned not null,
    foreign key (location_id) references locations(location_id)
) engine = innodb;
+-------------+--------------------+------+-----+---------+----------------+
| Field       | Type               | Null | Key | Default | Extra          |
+-------------+--------------------+------+-----+---------+----------------+
| session_id  | int unsigned       | NO   | PRI | NULL    | auto_increment |
| date_time   | datetime           | NO   |     | NULL    |                |
| location_id | mediumint unsigned | NO   | MUL | NULL    |                |
+-------------+--------------------+------+-----+---------+----------------+
-- add a record


-- CREATE AVAILABE_PAYMENT_TYPES TABLE
create table available_payment_types (
    payment_types_id int unsigned auto_increment primary key,
    payment_type varchar(255) not null,
    parent_id int unsigned not null,
    foreign key (parent_id) references parents(parent_id)
) engine = innodb;
+------------------+--------------+------+-----+---------+----------------+
| Field            | Type         | Null | Key | Default | Extra          |
+------------------+--------------+------+-----+---------+----------------+
| payment_types_id | int unsigned | NO   | PRI | NULL    | auto_increment |
| payment_type     | varchar(255) | NO   |     | NULL    |                |
| parent_id        | int unsigned | NO   | MUL | NULL    |                |
+------------------+--------------+------+-----+---------+----------------+
-- add a record


-- CREATE STUDENT_SESSION TABLE
create table student_session (
    student_session_id int unsigned auto_increment primary key,
    student_id int unsigned not null,
    session_id int unsigned not null,
    foreign key (student_id) references students(student_id),
    foreign key (session_id) references sessions(session_id)
) engine = innodb;
+--------------------+--------------+------+-----+---------+----------------+
| Field              | Type         | Null | Key | Default | Extra          |
+--------------------+--------------+------+-----+---------+----------------+
| student_session_id | int unsigned | NO   | PRI | NULL    | auto_increment |
| student_id         | int unsigned | NO   | MUL | NULL    |                |
| session_id         | int unsigned | NO   | MUL | NULL    |                |
+--------------------+--------------+------+-----+---------+----------------+
-- add a record


-- CREATE PAYMENTS TABLE
create table payments (
    payment_id int unsigned auto_increment primary key,
    payment_mode varchar(255) not null,
    amount float unsigned not null,
    parent_id int unsigned not null,
    student_id int unsigned not null,
    session_id int unsigned not null,
    foreign key (parent_id) references parents(parent_id),
    foreign key (student_id) references students(student_id),
    foreign key (session_id) references sessions(session_id)
) engine = innodb;
+--------------+----------------+------+-----+---------+----------------+
| Field        | Type           | Null | Key | Default | Extra          |
+--------------+----------------+------+-----+---------+----------------+
| payment_id   | int unsigned   | NO   | PRI | NULL    | auto_increment |
| payment_mode | varchar(255)   | NO   |     | NULL    |                |
| amount       | float unsigned | NO   |     | NULL    |                |
| parent_id    | int unsigned   | NO   | MUL | NULL    |                |
| student_id   | int unsigned   | NO   | MUL | NULL    |                |
| session_id   | int unsigned   | NO   | MUL | NULL    |                |
+--------------+----------------+------+-----+---------+----------------+
-- add a record