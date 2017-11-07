-- #1. Write a query against the Sales.Orders table that returns orders placed in June 2007.
-- Tables involved: TSQL2012 database and the Sales.Orders table

-- [1] -- 
SELECT orderid, orderdate, custid, empid 
FROM Sales.Orders
WHERE YEAR(orderdate) = 2007 AND MONTH(orderdate) = 6; 

-- [2] -- 
SELECT orderid, orderdate. custid, empID
FROM Sales.Orders
WHERE orderdate < '20070701' and orderdate >= '20070601';

-- [3] -- 
SELECT orderid, orderdate, custid, empid 
FROM Sales.Orders
WHERE DATEPART(MONTH, orderdate) = 6 AND DATEPART(YEAR, orderdate) = 2007;

-- #2. Write a query against the Sales.Orders table that returns orders placed on the last day of the month
-- Tables involved: TSQL2012 database and the Sales.Orders table

-- [1] -- 
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE DAY(orderdate) LIKE 
	CASE 
		WHEN (MONTH(orderdate) in (1,3,5,7,8,10,12) and DAY(orderdate) = 31) THEN
			DAY(orderdate)
		WHEN (MONTH(orderdate) in (4,6,9,11) and DAY(orderdate) = 30) THEN
			DAY(orderdate) 
		WHEN (MONTH(orderdate) = 2 and DAY(orderdate) = 28) THEN
			DAY(orderdate)
		WHEN (MONTH(orderdate) = 2 and DAY(orderdate) = 29) THEN
			DAY(orderdate)
	END;

-- [2] -- 
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate = EOMONTH(orderdate);

-- [3] -- 
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate = DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, orderdate) + 1, 0)) ;

-- #3. Write a query against the HR.Employees Table that returns employees with last name containing the letter a twice or more.
-- Tables involved: TSQL2012 database and the HR.Employees table

-- [1] -- 
SELECT empid, firstname, lastname
FROM HR.Employees
WHERE len(lastname) - len(replace(lastname, 'a', '')) >= 2;

-- [2] -- 
SELECT empid, firstname, lastname
FROM HR.Employees
WHERE lastname like '%a%a%';

-- [3] -- 
SELECT empid, firstname, lastname
FROM HR.Employees
WHERE CHARINDEX('a', lastname) > 0 AND CHARINDEX('a', STUFF(lastname, CHARINDEX('a', lastname), 1, '')) > 1;

-- #4*. Write a query against the Sales.OrderDetails table that returns orders with total value (quantity*unit-price) greater than 10k AND sort it by total value
-- Tables involved: TSQL2012 database and the Sales.OrderDetails table

-- [1] -- 
SELECT orderid, SUM(qty * unitprice) as totalvalue
FROM Sales.OrderDetails
GROUP BY orderid
HAVING SUM(qty * unitprice) > 10000 
ORDER BY totalvalue DESC;

-- [2] -- 
with cte1 as
(
    SELECT orderid, SUM(qty * unitprice) AS totalvalue
    FROM Sales.OrderDetails
    GROUP BY orderid
)
SELECT * FROM cte1
WHERE totalvalue > 10000;

-- [3] -- 
SELECT * FROM
(
	SELECT orderid, SUM(qty * unitprice) as totalvalue
	FROM Sales.OrderDetails
	GROUP BY orderid
) As A
WHERE A.totalvalue > 10000
ORDER BY A.totalvalue DESC;

-- #5. Write a query against the Sales.Orders table that returns the three shipped-to countries with the highest average freight in 2007.
-- Tables involved: TSQL2012 database and the Sales.Orders table

-- [1] -- 
SELECT TOP 3 shipcountry, AVG(freight) as avgfreight
FROM Sales.Orders
WHERE YEAR(orderdate) = 2007
GROUP BY shipcountry
ORDER BY avgfreight DESC;

-- [2] -- 
SELECT shipcountry, AVG(freight) as avgfreight
FROM Sales.Orders
WHERE YEAR(orderdate) = 2007
GROUP BY shipcountry
ORDER BY avgfreight DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;

-- [3] -- 
SELECT TOP 3 shipcountry, AVG(freight) as avgfreight
FROM Sales.Orders
WHERE orderdate < '20080101' AND orderdate >= '20070101'
GROUP BY shipcountry
ORDER BY avgfreight DESC;

-- #6. Write a query against the Sales.Orders table that calculates row numbers for orders based on order date ordering (using the order ID as the tiebreaker) for each customer separately.
-- Tables involved: TSQL2012 database and the Sales.Orders table

-- [1] -- 
SELECT custid, orderdate, orderid, ROW_NUMBER() OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS rownum
FROM Sales.Orders
ORDER BY custid, rownum 

-- [2] -- 
SELECT custid, orderdate, orderid
FROM Sales.Orders as SO1
	CROSS APPLY 
	(
		SELECT COUNT(*) + 1 AS rownum
		FROM Sales.Orders as SO2 
		WHERE SO1.custid = SO2.custid
		AND SO1.orderdate > SO2.orderdate
		AND SO1.orderid > SO2.orderid
	) SO2
ORDER BY custid, rownum;

-- #7. Using the HR.Employees table, figure out the SELECT statement that returns for each employee the
-- gender based on the title of courtesy. For ‘Ms. ‘ and ‘Mrs.’ return ‘Female’; for ‘Mr. ‘ return ‘Male’; and
-- in all other cases (for example, ‘Dr. ‘) return ‘Unknown’.
-- Tables involved: TSQL2012 database and the HR.Employees table

-- [1] -- 
SELECT empid, firstname, lastname, titleofcourtesy, 
		CASE titleofcourtesy
			WHEN 'Ms.' THEN 'Female'
			WHEN 'Mrs.' THEN 'Female'
			WHEN 'Mr.' THEN 'Male'
			ELSE 'Unknown'
		END as gender
FROM Hr.Employees;

-- [2] -- 
SELECT empid, firstname, lastname, titleofcourtesy, 
		CASE 
			WHEN titleofcourtesy = 'Ms.' THEN 'Female'
			WHEN titleofcourtesy = 'Mrs.' THEN 'Female'
			WHEN titleofcourtesy = 'Mr.' THEN 'Male'
			ELSE 'Unknown'
		END as gender
FROM Hr.Employees;

-- [3] -- 
SELECT empid, firstname, lastname, titleofcourtesy, 
		CASE 
			WHEN titleofcourtesy in('Ms.', 'Mrs.') THEN 'Female'
			WHEN titleofcourtesy = 'Mr.' THEN 'Male'
			ELSE 'Unknown'
		END as gender
FROM Hr.Employees;

-- #8. Write a query against the Sales.Customers table that returns for each customer the customer ID and
-- region. Sort the rows in the output by region, having NULL marks sort last (after non-NULL values).
-- Note that the default sort behavior for NULL marks in T-SQL is to sort first (before non-NULL values).
-- Tables involved: TSQL2012 database and the Sales.Customers table

-- [1] -- 
SELECT custid, region
FROM Sales.Customers
ORDER BY
CASE 
	WHEN region IS NULL THEN 1 
	ELSE 0 
END, region;

-- [2] -- 
SELECT custid, region
FROM Sales.Customers
ORDER BY
CASE 
	WHEN region IS NULL THEN 2 
	ELSE 1 
END, region;

-- [3] -- 
SELECT custid, region
FROM Sales.Customers
WHERE region is NOT NULL

UNION

SELECT custid, region
FROM Sales.Customers
WHERE region is NULL;
