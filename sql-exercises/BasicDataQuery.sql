https://www.mysqltutorial.org/tryit/

-- SELECT
-- Select allows us to select rows
-- * means all columns
-- this means display all cols from all rows in employees table
select * from employees; 
-- display specific cols to see
select firstName, lastName, email from employees;

-- Exercise on customers table
-- show only customers name, phone and city (can <describe customers;> first to show all columns in customers table)
select customerName, phone, city from customers;

-- select column and rename cols for better presentation
select customerName as "Customer Name", phone as "Contact", city as "City" from customers;


-- select only certain rows from certain cols
-- only get all employees from office code 1 in employees
-- USE WHERE TO FILTER ROWS
select * from employees where officeCode = 1;
select firstName, lastName, officeCode from employees where officeCode = 1;
-- exercise show all offices in USA (show city address line 1 and 2)
select city, addressLine1, addressLine2 from offices where country = "USA";


-- LIKE (case insensitive)
-- = is a direct match
select * from employees where jobTitle = "Sales Rep";
-- like + % wildcard matches job titles starts with sales
select * from employees where jobTitle like "Sales%";
-- matches job titles that end with sales
select * from employees where jobTitle like "%Sales";
-- matches job titles that has sales anywhere
select * from employees where jobTitle like "%sales%";
-- exercise find all productNames whose name being with 1969
select productName from products where productName like "1969%";
-- exercise find all products whos name contains the string davidson
select * from products where productName like "%davidson%";


-- SEARCH WITH MULTIPLE CONDITIONS
-- find all sales rep from office code 1
select * from employees where officeCode=1 
    and jobTitle like "sales rep";
-- find all employees from office code 1 or 2
select * from employees where officeCode=1
    or officeCode=2;
-- show all sales rep from officecode 1 or 2
-- select * from employees where (jobTitle like "sales rep" and officeCode=1) or officeCode=2; is wrong because AND has higher priority see invisible parenthesis
select * from employees where jobTitle like "sales rep" and (officeCode=1 or officeCode=2); 
-- exercise show all customers from USA, state nV with credit limit > 5000 OR customers from any country with credit limit > 10000
select * from customers where (country = "USA" and state = "nv" and creditLimit > 5000) or (creditLimit > 10000);


-- JOIN DATA FROM MULTIPLE TABLES
-- join creates a temporary table and does not affect the original table
select * from employees join offices 
    on employees.officeCode = offices.officeCode;
-- table will happen first, join will happen next, where will happen last
select firstName, lastName, city, addressLine1, addressLine2 from employees join offices
    on employees.officeCode = offices.officeCode
    where country = "USA";
-- exercise show customer name along with first name, last name and email of their sales rep
-- if col names are the same across 2 tables, can use <tablename>.<col name> to differentiate (eg. employees.name)
-- fk DOES NOT need to be the same name across both tables
select customerName, salesRepEmployeeNumber, firstName, lastName, email 
    from customers join employees
    on customers.salesRepEmployeeNumber = employees.employeeNumber;
-- aggregate
-- this will return all customers with a sales rep assigned to it
select count(*) 
    from customers join employees
    on customers.salesRepEmployeeNumber = employees.employeeNumber;
-- left join all customers even though they have no sales rep assigned
select customerName, salesRepEmployeeNumber, firstName, lastName, email 
    from customers left join employees
    on customers.salesRepEmployeeNumber = employees.employeeNumber;
-- right join employees that have no customers
select customerName, salesRepEmployeeNumber, firstName, lastName, email 
    from customers right join employees
    on customers.salesRepEmployeeNumber = employees.employeeNumber;

-- 3 WAY JOIN
-- for each customer in the USA, show the name of their sales rep and office number
select customerName as "Customer Name", customers.country as "Customer Country", firstName, lastName, offices.phone from customers join employees
    on customers.salesRepEmployeeNumber = employees.employeeNumber
    join offices
    on employees.officeCode = offices.officeCode
    where customers.country="usa";


-- DATE MANIPULATION
-- current date on server
select curdate();
-- current date and time 
select now();
-- if want to compare dates , need to use datetime data type NEVER STORE DATES AS VARCHAR
-- see all payments made after june 2003
select * from payments where paymentDate > "2003-06-30";
-- show all payments between 1 jan 2003 and 30 jun 2003
select * from payments where paymentDate >= "2003-01-01" and paymentDate <= "2003-06-30";
select * from payments where paymentDate between "2003-01-01" and "2003-06-30";
-- display the years where a payment is made (DOES NOT WITH WITH VARCHAR)
select checkNumber, year(paymentDate) from payments
    where year(paymentDate) = 2003;
select checkNumber, year(paymentDate), month(paymentDate), day(paymentDate) from payments;



-- AGGREGATION FUNCTIONS
-- similar to reducing function in array
-- count how many rows there are in a table
select count(*) from employees;

-- sum allows sum of values of a column across all the rows
select sum(quantityOrdered) from orderdetails;

select sum(quantityOrdered) as "Sum of S18_1749" from orderdetails
    where productCode = "S18_1749";

select sum(quantityOrdered * priceEach) as "Total sales from S18_1749"from orderdetails
    where productCode = "S18_1749";

-- count how many customers there are with sales rep
select count(*) from customers join employees
    on customers.salesRepEmployeeNumber = employees.employeeNumber;

-- find the total amount paid by customers in the month of june 2013
select sum(amount) from payments    
    -- where paymentDate between "2003-06-01" and "2003-06-30";
    where month(paymentDate) = 6 and year(paymentDate) = 2003;

avg(amount) is average


--  GROUP BY
-- how many customers FOR EACH country
-- select * from customers where country = "france"
-- select * from customers where country = "USA"
-- select * from customers where country = "Singapore"
-- select * from customers where country = "china"
STEP1: select ?? from customers
    group by country
-- group by happens first, then select will happen FOR EACH group, hence count by country
-- only the group by field (country) can be select, all other arguments in select MUST be aggregate functions
select country, count(*) from customers
    group by country;

-- see avg customers credit limit by country
select country, avg(creditLimit), count(*) from customers
    group by country
    order by count(*) desc;

-- show per country, for sales rep 1504, the average credit limit
-- where happens BEFORE group by, group by will run on the filtered results
select salesRepEmployeeNumber, employees.firstName, employees.lastName, employees.email, country, avg(creditLimit), count(*) from customers
    join employees on customers.salesRepEmployeeNumber = employees.employeeNumber
    where salesRepEmployeeNumber = 1504
    group by country, firstName, lastName, email
    order by avg(creditLimit) desc
    limit 3;
-- Hierarchy of what happens (F W G S O)
-- 1. from/join
-- 2. where (filter from/join)
-- 3. group by
-- 4. having (filter group)
-- 5. select 
-- 6. order by
-- 7. limit
-- search only full group by error for later versions of sql

select country, count(* from customers)
    group by country
    having count(*) > 5;


-- SUB QUERY
-- show product code from product that has been ordered the most times
select orderdetails.productCode from (orderdetails.productCode, count(*) from orderdetails
    group by orderdetails.productCode
    order by count(*) desc
    limit 1) as sub;

-- show customers whose credit limit is above avg
select avg(creditLimit) from customers ##this displays the avg credit limit for all customers (67659.016393)
-- can hardcode
select * from customers where creditLimit > 67659.016393
-- alternatively,
-- when select returns only 1 value, it will be treated as a primitive
select * from customers where creditLimit > (select avg(creditLimit) from customers);

-- show products that have not been ordered before
-- distinct will remove duplicates
-- this will generate an array of product codes
select distinct productCode from orderdetails; 

select * from products where productCode not in (select distinct productCode from orderdetails);

-- find employees that contribute more than 10% of all payments
-- find 10% of payments
select employeeNumber, sum(amount) from employees 
    join customers on employees.employeeNumber = customers.salesRepEmployeeNumber
    join payments on customers.customerNumber = payments.customerNumber
    group by employees.employeeNumber
    having sum(amount) > (more than 10% of all payments made)

select employeeNumber, sum(amount) from employees 
    join customers on employees.employeeNumber = customers.salesRepEmployeeNumber
    join payments on customers.customerNumber = payments.customerNumber
    group by employees.employeeNumber
    having sum(amount) > (select sum(amount) * 0.1 from payments);
