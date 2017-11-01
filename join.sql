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

/* Notes:
	A CROSS JOIN simply takes the cross product without any restraints.
	Thus, we utilize this with the arbitrary xid that is an element of [1. 600] to manipulate 5 copies of each employee row.
*/

-- #1.2 Write a query that returns a row for each employee and day in the range June 12, 2009 through
-- June 16, 2009.
-- Tables involved: HR.Employees and dbo.Nums

SELECT HR.Employees.empid,
DATEADD(day, D.xid - 1, '20090612') AS dt
FROM HR.Employees 
CROSS JOIN dbo.Nums AS D
WHERE D.xid <= DATEDIFF(day, '20090612', '20090616') + 1
ORDER BY empid, dt;

/* Notes:
	DATEADD (datepart , number , date )  -- Returns a specified date.
		datepart -- the part of a date that will be affected
		number --  an expression that represents the change in the datepart
		date -- the actual initial date

	DATEDIFF ( datepart , startdate , enddate )  -- Returns a datepart int of the difference between the start and end date 
		datepart -- the part of a date that is of interest
		startdate -- the start date
		enddate -- the ending date
*/

-- #2 Return United States customers, and for each customer return the total number of orders and total
-- quantities.
-- Tables involved: Sales.Customers, Sales.Orders, and Sales.OrderDetails

SELECT Sales.Customers.custid, 
		COUNT(DISTINCT Sales.Orders.orderid) AS numorders, 
		SUM(Sales.OrderDetails.qty) AS totalqty
FROM Sales.Customers 
JOIN Sales.Orders 
ON Sales.Orders.custid = Sales.Customers.custid
JOIN Sales.OrderDetails 
ON Sales.OrderDetails.orderid = Sales.Orders.orderid
WHERE Sales.Customers.country = N'USA'
GROUP BY Sales.Customers.custid;

/* Notes:
	COUNT ( { [ [ ALL | DISTINCT ] expression ] | * } )  
		-- Returns the number of items in a group. In this case, COUNT will return the number of distinct (nonnull) orders

	The general procedure is to find the common fields between two tables. 
		Sales.Customers and Sales.Orders share custid while Sales.Orders and Sales.OrderDetails share orderid
*/

-- #3 Return customers and their orders, including customers who placed no orders.
-- Tables involved: Sales.Customers and Sales.Orders

SELECT Sales.Customers.custid, Sales.Customers.companyname, Sales.Orders.orderid, Sales.Orders.orderdate
FROM Sales.Customers
LEFT JOIN Sales.Orders
ON Sales.Orders.custid = Sales.Customers.custid;

/* Notes:
	We perform a LEFT JOIN because we want to be inclusive of all customers (table1) regardless if they placed an order or not
*/

-- #4 Return customers who placed no orders.
-- Tables involved: Sales.Customers and Sales.Orders

SELECT Sales.Customers.custid, Sales.Customers.companyname
FROM Sales.Customers
LEFT JOIN Sales.Orders
ON Sales.Orders.custid = Sales.Customers.custid
WHERE Sales.Orders.orderid IS NULL;

/* Notes:
	We perform a LEFT JOIN because we want to be inclusive of all customers (table1) regardless if they placed an order or not

	We additionally want to filter our answer to just customers who placed no orders and thus utilize WHERE.
*/

