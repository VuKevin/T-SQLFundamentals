-- #1.1 Write a query that generates five copies of each employee row.
-- Tables involved: HR.Employees and dbo.Nums

-- [1] -- 
SELECT Hr.Employees.empid, Hr.Employees.firstname, HR.Employees.lastname, N.xid
FROM HR.Employees 
CROSS JOIN dbo.Nums as N
WHERE N.xid <= 5
ORDER BY xid, empid; 

-- [2] -- 
SELECT Hr.Employees.empid, Hr.Employees.firstname, HR.Employees.lastname, N.xid
FROM HR.Employees 
LEFT JOIN dbo.Nums as N
ON N.xid <= 5
ORDER BY xid, empid;

-- [3] -- 
DECLARE @Placeholders TABLE
	(n integer)
INSERT INTO @Placeholders
	Values (1), (2), (3), (4), (5), (6);

SELECT Hr.Employees.empid, Hr.Employees.firstname, HR.Employees.lastname, N.n
FROM HR.Employees 
CROSS JOIN @Placeholders as N
WHERE N.n <= 5
ORDER BY n, empid; 

-- #1.2 Write a query that returns a row for each employee and day in the range June 12, 2009 through
-- June 16, 2009.
-- Tables involved: HR.Employees and dbo.Nums

-- [1] -- 
SELECT HR.Employees.empid,
DATEADD(day, D.xid - 1, '20090612') AS dt
FROM HR.Employees 
CROSS JOIN dbo.Nums AS D
WHERE D.xid <= DATEDIFF(day, '20090612', '20090616') + 1
ORDER BY empid, dt;

-- [2] -- 
SELECT HR.Employees.empid,
DATEADD(day, D.xid - 1, '20090612') AS dt
FROM HR.Employees 
CROSS JOIN dbo.Nums AS D
WHERE D.xid <= CAST(20090616-20090612+1 AS Integer)
ORDER BY empid, dt;

-- [3] -- 
SELECT HR.Employees.empid,
DATEADD(day, D.xid - 1, '20090612') AS dt
FROM HR.Employees 
CROSS JOIN dbo.Nums AS D
WHERE D.xid <=	
	(
		SELECT (20090616-20090612+1) as DaysDiff
	)
ORDER BY empid, dt;

-- #2 Return United States customers, and for each customer return the total number of orders and total
-- quantities.
-- Tables involved: Sales.Customers, Sales.Orders, and Sales.OrderDetails

-- [1] -- 
SELECT Sales.Customers.custid, 
		COUNT(DISTINCT Sales.Orders.orderid) AS numorders, 
		SUM(Sales.OrderDetails.qty) AS totalqty
FROM Sales.Customers 
JOIN Sales.Orders 
ON Sales.Orders.custid = Sales.Customers.custid
JOIN Sales.OrderDetails 
ON Sales.OrderDetails.orderid = Sales.Orders.orderid
WHERE Sales.Customers.country = 'USA'
GROUP BY Sales.Customers.custid;

-- [2] -- 
SELECT Sales.Customers.custid, 
		COUNT(DISTINCT Sales.Orders.orderid) AS numorders, 
		SUM(Sales.OrderDetails.qty) AS totalqty
FROM Sales.Customers, Sales.Orders, Sales.OrderDetails
WHERE Sales.Customers.custid = Sales.Orders.custid
AND Sales.Orders.orderid = Sales.OrderDetails.orderid 
AND Sales.Customers.country = 'USA'
GROUP BY Sales.Customers.custid;

-- [3] -- 
SELECT DISTINCT Sales.Customers.custid,
		COUNT(DISTINCT Sales.Orders.orderid) AS numorders, 
		SUM(Sales.OrderDetails.qty) AS totalqty
FROM Sales.Customers 
JOIN Sales.Orders 
ON Sales.Orders.custid = Sales.Customers.custid
JOIN Sales.OrderDetails 
ON Sales.OrderDetails.orderid = Sales.Orders.orderid
WHERE Sales.Customers.country = 'USA'
ORDER BY Sales.Customers.custid;

-- #3 Return customers and their orders, including customers who placed no orders.
-- Tables involved: Sales.Customers and Sales.Orders

-- [1] -- 
SELECT Sales.Customers.custid, Sales.Customers.companyname, Sales.Orders.orderid, Sales.Orders.orderdate
FROM Sales.Customers
LEFT JOIN Sales.Orders
ON Sales.Orders.custid = Sales.Customers.custid;

-- [2] -- 
SELECT Sales.Customers.custid, Sales.Customers.companyname, Sales.Orders.orderid, Sales.Orders.orderdate
FROM Sales.Orders
RIGHT JOIN Sales.Customers
ON Sales.Orders.custid = Sales.Customers.custid;

-- [3] -- 
SELECT Sales.Customers.custid, Sales.Customers.companyname, Sales.Orders.orderid, Sales.Orders.orderdate
FROM Sales.Customers, Sales.Orders
WHERE Sales.Customers.custid *= Sales.Orders.custid;

-- #4 Return customers who placed no orders.
-- Tables involved: Sales.Customers and Sales.Orders

-- [1] -- 
SELECT Sales.Customers.custid, Sales.Customers.companyname
FROM Sales.Customers
LEFT JOIN Sales.Orders
ON Sales.Orders.custid = Sales.Customers.custid
WHERE Sales.Orders.orderid IS NULL;

-- [2] -- 
SELECT Sales.Customers.custid, Sales.Customers.companyname
FROM Sales.Orders
RIGHT JOIN Sales.Customers
ON Sales.Orders.custid = Sales.Customers.custid
WHERE Sales.Orders.orderid IS NULL;

-- [3] -- 
SELECT Sales.Customers.custid, Sales.Customers.companyname
FROM Sales.Customers
LEFT JOIN Sales.Orders
ON Sales.Orders.custid = Sales.Customers.custid
GROUP BY Sales.Customers.custid, Sales.Customers.companyname
HAVING 1 = MAX
(
	CASE WHEN Sales.Orders.orderid IS NULL THEN 1 ELSE 0 END
)

-- #5 Return customers with orders placed on February 12, 2007, along with their orders.
-- Tables involved: Sales.Customers and Sales.Orders

-- [1] -- 
SELECT Sales.Customers.custid, Sales.Customers.companyname, Sales.Orders.orderid, Sales.Orders.orderdate
FROM Sales.Customers 
JOIN Sales.Orders
On Sales.Orders.custid = Sales.Customers.custid
WHERE Sales.Orders.orderdate = '20070212';

-- [2] -- 
SELECT Sales.Customers.custid, Sales.Customers.companyname, Sales.Orders.orderid, Sales.Orders.orderdate
FROM Sales.Customers 
JOIN Sales.Orders
On Sales.Orders.custid = Sales.Customers.custid
WHERE Month(Sales.Orders.orderdate) = 2 and Day(Sales.Orders.orderdate) = 12 and Year(Sales.Orders.orderdate) = 2007;

-- [3] -- 
SELECT Sales.Customers.custid, Sales.Customers.companyname, Sales.Orders.orderid, Sales.Orders.orderdate
FROM Sales.Customers 
JOIN Sales.Orders
On Sales.Orders.custid = Sales.Customers.custid
WHERE DATEPART(MONTH, Sales.Orders.orderdate) = 2 AND DATEPART(YEAR, Sales.Orders.orderdate) = 2007 and  DATEPART(DAY, Sales.Orders.orderdate) = 12;

-- #6 Return customers with orders placed on February 12, 2007, along with their orders. Also return customers
-- who didn’t place orders on February 12, 2007.
-- Tables involved: Sales.Customers and Sales.Orders

-- [1] -- 
SELECT Sales.Customers.custid, Sales.Customers.companyname, Sales.Orders.orderid, Sales.Orders.orderdate
FROM Sales.Customers 
LEFT JOIN Sales.Orders
On Sales.Orders.custid = Sales.Customers.custid
AND Sales.Orders.orderdate = '20070212';

-- [2] -- 
SELECT Sales.Customers.custid, Sales.Customers.companyname, Sales.Orders.orderid, Sales.Orders.orderdate
FROM Sales.Customers 
LEFT JOIN Sales.Orders
On Sales.Orders.custid = Sales.Customers.custid
AND Month(Sales.Orders.orderdate) = 2 and Day(Sales.Orders.orderdate) = 12 and Year(Sales.Orders.orderdate) = 2007;

-- [3] -- 
SELECT Sales.Customers.custid, Sales.Customers.companyname, Sales.Orders.orderid, Sales.Orders.orderdate
FROM Sales.Customers 
LEFT JOIN Sales.Orders
On Sales.Orders.custid = Sales.Customers.custid
AND DATEPART(MONTH, Sales.Orders.orderdate) = 2 AND DATEPART(YEAR, Sales.Orders.orderdate) = 2007 and  DATEPART(DAY, Sales.Orders.orderdate) = 12;

-- #7 Return all customers, and for each return a Yes/No value depending on whether the customer placed
-- an order on February 12, 2007.
-- Tables involved: Sales.Customers and Sales.Orders

-- [1] -- 
SELECT DISTINCT Sales.Customers.custid, Sales.Customers.companyname, 
	CASE
		WHEN Sales.Orders.orderdate = '20070212' THEN 'Yes'
		ELSE 'No'
	END as HasOrderOn20070212
FROM Sales.Customers 
LEFT JOIN Sales.Orders
ON Sales.Orders.custid = Sales.Customers.custid
AND Sales.Orders.orderdate = '20070212';

-- [2] -- 
SELECT DISTINCT Sales.Customers.custid, Sales.Customers.companyname, 
	CASE
		WHEN Sales.Orders.orderdate IS NOT NULL THEN 'Yes'
		ELSE 'No'
	END as HasOrderOn20070212
FROM Sales.Customers 
LEFT JOIN Sales.Orders
ON Sales.Orders.custid = Sales.Customers.custid
AND Sales.Orders.orderdate = '20070212';

-- [3] -- 
SELECT Sales.Customers.custid, Sales.Customers.companyname, 
	CASE
		WHEN Sales.Orders.orderdate = '20070212' THEN 'Yes'
		ELSE 'No'
	END as HasOrderOn20070212
From Sales.Customers, Sales.Orders
WHERE Sales.Orders.custid = Sales.Customers.custid
AND Sales.Orders.orderdate = '20070212'

UNION 

SELECT Sales.Customers.custid, Sales.Customers.companyname, 'No' AS HasOrderOn20070212
FROM Sales.Customers 
WHERE NOT EXISTS
(
	SELECT 1 FROM Sales.Orders 
	WHERE Sales.Orders.custid = Sales.Customers.custid
	AND Sales.Orders.orderdate = '20070212'
);

-- [4] --
SELECT Sales.Customers.custid, Sales.Customers.companyname, 'no' as HasOrderOn2007022012
FROM Sales.Customers
JOIN Sales.Orders
ON Sales.Orders.custid = Sales.Customers.custid

UNION 

SELECT Sales.Customers.custid, Sales.Customers.companyname, 'yes' as HasOrderOn2007022012
FROM Sales.Customers
LEFT JOIN Sales.Orders
ON Sales.Orders.custid = Sales.Customers.custid
WHERE Sales.Orders.orderdate = '20070212';
