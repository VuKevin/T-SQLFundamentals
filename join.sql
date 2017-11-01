USE HPS;

SELECT * FROM HR.Employees;
SELECT * FROM dbo.Nums;

-- #1.1 Write a query that generates five copies of each employee row.
-- Tables involved: HR.Employees and dbo.Nums

SELECT Hr.Employees.empid, Hr.Employees.firstname, HR.Employees.lastname, N.xid
FROM HR.Employees 
CROSS JOIN dbo.Nums as N
WHERE N.xid <= 5
ORDER BY xid, empid;  

-- #1.2 Write a query that returns a row for each employee and day in the range June 12, 2009 through
-- June 16, 2009.
-- Tables involved: HR.Employees and dbo.Nums

-- #2 Return United States customers, and for each customer return the total number of orders and total
-- quantities.
-- Tables involved: Sales.Customers, Sales.Orders, and Sales.OrderDetails

-- #3 Return customers and their orders, including customers who placed no orders.
-- Tables involved: Sales.Customers and Sales.Orders

-- #4 Return customers who placed no orders.
-- Tables involved: Sales.Customers and Sales.Orders

-- #5 Return customers with orders placed on February 12, 2007, along with their orders.
-- Tables involved: Sales.Customers and Sales.Orders

-- #6 Return customers with orders placed on February 12, 2007, along with their orders. Also return customers
-- who didn’t place orders on February 12, 2007.
-- Tables involved: Sales.Customers and Sales.Orders

-- #7 Return all customers, and for each return a Yes/No value depending on whether the customer placed
-- an order on February 12, 2007.
-- Tables involved: Sales.Customers and Sales.Orders
