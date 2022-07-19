-- MySQL Select Practices in Classroom
-- 1. find all the offices and display only their city, phone and country
select city, phone, country from offices;

-- 2. find all rows in the orders table that mentions FedEx in the comments
select * from orders
    where comments like "%fedex%";

-- 3. show the contact firstName and contact lastName of all customers in descending order by the customers name
select contactFirstName, contactLastName, customerName from customers
    order by customerName desc;

-- 4. find all sales rep who are in office code 1,2,3 and their first name or last name contains the substring "son"
select * from employees 
    where (officeCode=1 or officeCode=2 or officeCode=3) and
    (firstname like "%son%" or lastName like "%son%") and
    jobTitle = "Sales Rep";
    
-- 5. display all the orders bought by the customer with the customer number 124, along with the customer name, the contact's first name and the contact's last name
select orders.orderNumber, orderdetails.productCode, orderdetails.quantityOrdered, orders.customerNumber, customers.customerName, customers.contactFirstName, customers.contactLastName from orders join customers
    on orders.customerNumber = customers.customerNumber
    join orderdetails
    on orders.orderNumber = orderdetails.orderNumber
    where customers.customerNumber = 124;

-- 6. Show the name of the product, together with the order details,  for each order line from the orderdetails table
select orderdetails.*, products.productName from orderdetails join products
    on orderdetails.productCode = products.productCode;

-- 7. Display sum of all the payments made by each company from the USA. 
select payments.customerNumber, customers.customerName, sum(payments.amount), customers.country from payments
    join customers on payments.customerNumber = customers.customerNumber
    where customers.country = "usa"
    group by customerNumber, customerName, customers.country;

-- 8. Show how many employees are there for each state in the USA
select state, count(*) from employees
    join offices on employees.officeCode = offices.officeCode
    where country = "usa"
    group by state;

-- 9. From the payments table, display the average amount spent by each customer. Display the name of the customer as well.
select payments.customerNumber, customerName, avg(amount) from payments
    join customers on payments.customerNumber = customers.customerNumber
    group by payments.customerNumber, customerName;

-- 10. From the payments table, display the average amount spent by each customer but only if the customer has spent a minimum of 10,000 dollars.
select payments.customerNumber, customerName, avg(amount), sum(amount) from payments
    join customers on payments.customerNumber = customers.customerNumber
    group by payments.customerNumber, customerName
    having sum(amount) >= 10000
    order by sum(amount);

-- 11. For each product, display how many times it was ordered, and display the results with the most orders first and only show the top ten.
select orderdetails.productCode, count(*) from orderdetails
    group by orderdetails.productCode
    order by count(*) desc
    limit 10;

-- 12. Display all orders made between Jan 2003 and Dec 2003
select * from orders
    where year(orderDate) = 2003;


-- 13. Display all the number of orders made, per month, between Jan 2003 and Dec 2003