-- data definition language

-- create database
create database employees;
-- show databases
show databases;
-- use specific database
use employees;
-- to see which database are u at
select database();

-- create first table (employees)
create table employees (
	employee_id int unsigned auto_increment primary key,
	email varchar(320),
	gender varchar(1),
	notes text,
	employment_date date,
	designation varchar(100)
) engine = innodb;

create table departments(
    department_id int unsigned auto_increment primary key,
    name varchar(100)
) engine = innodb;

-- show table
show tables;
-- show columns in table
describe employees;
-- delete table
drop table employees;

-- inserting rows (leave pri key blank...it is auto filled)
insert into employees(
    email, gender, notes, employment_date, designation
) values(
    "asd@asd.com", "m", "Newbie", curdate(), "Intern"
);

insert into employees(
    email, gender, notes, employment_date, designation, first_name
) values(
    "abc@abc.com", "m", "Noob", curdate(), "Trainee", "Tan Ah Kow"
);

insert into departments(
    name
) values (
    "human resources"
); 

insert into departments(
    name
) values (
    "finance"
);

insert into departments(
    name
) values (
    "administration"
);

insert into departments(
    name
) values (
    "sales"
);

-- see all the rows in a table
select * from employees;

-- update one row in a table (change email from asd.com to gmail.com)
update employees set email="asd@gmail.com" where employee_id = 1;

-- delete one row
delete from employees where employee_id = 1;


-- add a new column to an existing table 
alter table employees add column name varchar(100);
-- alter table can also do rename 
alter table employees rename column name to first_name;

-- insert two or three rows
insert into departments (name) values ("IT"),("Accounting"),("Facilities");

-- adding in a foreign key between employees and departments (data type of fk MUST match data type of corresponding pk) not null because its a fk
-- 1. add column
alter table employees add column department_id int unsigned not null; 
-- 2. indicate newly added column to be fk
alter table employees add constraint fk_employees_departments
    foreign key (department_id) references departments(department_id);
-- 3. delete from existing employee (so that we can add in the foreign key)
delete from employees;

insert into employees (first_name, department_id, email, gender, notes, employment_date, designation)
values("Tan Ah Kow", 4, "tanahkow@email.com", "m", "Newbie", curdate(), "Intern");