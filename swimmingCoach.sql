-- create parents table
create table parents(
    parent_id int unsigned auto_increment primary key,
    name varchar(100) not null,
    contact_no varchar(10) not null,
    occupation varchar(100)
);
+------------+--------------+------+-----+---------+----------------+
| Field      | Type         | Null | Key | Default | Extra          |
+------------+--------------+------+-----+---------+----------------+
| parent_id  | int unsigned | NO   | PRI | NULL    | auto_increment |
| name       | varchar(100) | NO   |     | NULL    |                |
| contact_no | varchar(10)  | NO   |     | NULL    |                |
| occupation | varchar(100) | YES  |     | NULL    |                |
+------------+--------------+------+-----+---------+----------------+

-- create students table
create table students (
    student_id int unsigned auto_increment primary key,
    name varchar(100) not null,
    date_of_birth date not null,
    parent_id int unsigned not null
);
+---------------+--------------+------+-----+---------+----------------+
| Field         | Type         | Null | Key | Default | Extra          |
+---------------+--------------+------+-----+---------+----------------+
| student_id    | int unsigned | NO   | PRI | NULL    | auto_increment |
| name          | varchar(100) | NO   |     | NULL    |                |
| date_of_birth | date         | NO   |     | NULL    |                |
| parent_id     | int unsigned | NO   |     | NULL    |                |
+---------------+--------------+------+-----+---------+----------------+

-- create addresses table
create table addresses (
    address_id int unsigned auto_increment primary key,
    street_name varchar(100) not null,
    postal_code varchar(100) not null,
    parent_id int unsigned not null
);
+-------------+--------------+------+-----+---------+----------------+
| Field       | Type         | Null | Key | Default | Extra          |
+-------------+--------------+------+-----+---------+----------------+
| address_id  | int unsigned | NO   | PRI | NULL    | auto_increment |
| street_name | varchar(100) | NO   |     | NULL    |                |
| postal_code | varchar(100) | NO   |     | NULL    |                |
| parent_id   | int unsigned | NO   |     | NULL    |                |
+-------------+--------------+------+-----+---------+----------------+

-- create available_payment_types table
create table available_payment_types (
    payment_types_id int unsigned auto_increment primary key,
    payment_type varchar(255) not null,
    parent_id int unsigned not null
);
+------------------+--------------+------+-----+---------+----------------+
| Field            | Type         | Null | Key | Default | Extra          |
+------------------+--------------+------+-----+---------+----------------+
| payment_types_id | int unsigned | NO   | PRI | NULL    | auto_increment |
| payment_type     | varchar(255) | NO   |     | NULL    |                |
| parent_id        | int unsigned | NO   |     | NULL    |                |
+------------------+--------------+------+-----+---------+----------------+

-- create sessions table
create table sessions(
    session_id int unsigned auto_increment primary key,
    date_time datetime not null,
    location_id int unsigned not null
);
+-------------+--------------+------+-----+---------+----------------+
| Field       | Type         | Null | Key | Default | Extra          |
+-------------+--------------+------+-----+---------+----------------+
| session_id  | int unsigned | NO   | PRI | NULL    | auto_increment |
| date_time   | datetime     | NO   |     | NULL    |                |
| location_id | int unsigned | NO   |     | NULL    |                |
+-------------+--------------+------+-----+---------+----------------+

-- create student_session table
create table student_session (
    student_session_id int unsigned auto_increment primary key,
    student_id int unsigned not null,
    session_id int unsigned not null
);
+--------------------+--------------+------+-----+---------+----------------+
| Field              | Type         | Null | Key | Default | Extra          |
+--------------------+--------------+------+-----+---------+----------------+
| student_session_id | int unsigned | NO   | PRI | NULL    | auto_increment |
| student_id         | int unsigned | NO   |     | NULL    |                |
| session_id         | int unsigned | NO   |     | NULL    |                |
+--------------------+--------------+------+-----+---------+----------------+

-- create payments table 
create table payments (
    payment_id int unsigned auto_increment primary key,
    payment_mode varchar(255) not null,
    amount float unsigned not null,
    parent_id int unsigned not null,
    student_id int unsigned not null,
    session_id int unsigned not null
);
+--------------+----------------+------+-----+---------+----------------+
| Field        | Type           | Null | Key | Default | Extra          |
+--------------+----------------+------+-----+---------+----------------+
| payment_id   | int unsigned   | NO   | PRI | NULL    | auto_increment |
| payment_mode | varchar(255)   | NO   |     | NULL    |                |
| amount       | float unsigned | NO   |     | NULL    |                |
| parent_id    | int unsigned   | NO   |     | NULL    |                |
| student_id   | int unsigned   | NO   |     | NULL    |                |
| session_id   | int unsigned   | NO   |     | NULL    |                |
+--------------+----------------+------+-----+---------+----------------+

-- create locations table
create table locations (
    location_id int unsigned auto_increment primary key,
    name varchar(100) not null,
    address varchar(255) not null
);
+-------------+--------------+------+-----+---------+----------------+
| Field       | Type         | Null | Key | Default | Extra          |
+-------------+--------------+------+-----+---------+----------------+
| location_id | int unsigned | NO   | PRI | NULL    | auto_increment |
| name        | varchar(100) | NO   |     | NULL    |                |
| address     | varchar(255) | NO   |     | NULL    |                |
+-------------+--------------+------+-----+---------+----------------+


-- add foreign key (parent_id) in addresses, students and available_payment_types table
alter table addresses add constraint fk_addresses_parents
    foreign key (parent_id) references parents(parent_id);
    +-------------+--------------+------+-----+---------+----------------+
| Field       | Type         | Null | Key | Default | Extra          |
+-------------+--------------+------+-----+---------+----------------+
| address_id  | int unsigned | NO   | PRI | NULL    | auto_increment |
| street_name | varchar(100) | NO   |     | NULL    |                |
| postal_code | varchar(100) | NO   |     | NULL    |                |
| parent_id   | int unsigned | NO   | MUL | NULL    |                |
+-------------+--------------+------+-----+---------+----------------+

alter table students add constraint fk_students_parents
    foreign key (parent_id) references parents(parent_id);
    +---------------+--------------+------+-----+---------+----------------+
| Field         | Type         | Null | Key | Default | Extra          |
+---------------+--------------+------+-----+---------+----------------+
| student_id    | int unsigned | NO   | PRI | NULL    | auto_increment |
| name          | varchar(100) | NO   |     | NULL    |                |
| date_of_birth | date         | NO   |     | NULL    |                |
| parent_id     | int unsigned | NO   | MUL | NULL    |                |
+---------------+--------------+------+-----+---------+----------------+

alter table available_payment_types add constraint fk_available_payment_types_parents
    foreign key (parent_id) references parents(parent_id);
    +------------------+--------------+------+-----+---------+----------------+
| Field            | Type         | Null | Key | Default | Extra          |
+------------------+--------------+------+-----+---------+----------------+
| payment_types_id | int unsigned | NO   | PRI | NULL    | auto_increment |
| payment_type     | varchar(255) | NO   |     | NULL    |                |
| parent_id        | int unsigned | NO   | MUL | NULL    |                |
+------------------+--------------+------+-----+---------+----------------+

-- add fk (location_id) to sessions table
alter table sessions add constraint fk_sessions_locations
    foreign key (location_id) references locations (location_id);
    +-------------+--------------+------+-----+---------+----------------+
| Field       | Type         | Null | Key | Default | Extra          |
+-------------+--------------+------+-----+---------+----------------+
| session_id  | int unsigned | NO   | PRI | NULL    | auto_increment |
| date_time   | datetime     | NO   |     | NULL    |                |
| location_id | int unsigned | NO   | MUL | NULL    |                |
+-------------+--------------+------+-----+---------+----------------+

-- add fk (student_id , session_id) to student_session table
alter table student_session add constraint fk_student_session_students
    foreign key (student_id) references students(student_id);

alter table student_session add constraint fk_student_session_sessions
    foreign key (session_id) references sessions(session_id);
+--------------------+--------------+------+-----+---------+----------------+
| Field              | Type         | Null | Key | Default | Extra          |
+--------------------+--------------+------+-----+---------+----------------+
| student_session_id | int unsigned | NO   | PRI | NULL    | auto_increment |
| student_id         | int unsigned | NO   | MUL | NULL    |                |
| session_id         | int unsigned | NO   | MUL | NULL    |                |
+--------------------+--------------+------+-----+---------+----------------+

-- add fk (parent_id, session_id, student_id) to payments table
alter table payments add constraint fk_payments_parents
    foreign key (parent_id) references parents(parent_id);

alter table payments add constraint fk_payments_students
    foreign key (student_id) references students(student_id);

alter table payments add constraint fk_payments_sessions
    foreign key (session_id) references sessions (session_id);
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
