USE HPS;
SELECT * FROM HR.Employees;
--  {orderid, custid, empid, orderdate, requireddate, shippeddate, shipperid, freight, shipname, shipaddress, shipcity, shipregion, shippostalcode, shipcountry} ∈ Sales.Orders

-- #1. Write a query against the Sales.Orders table that returns orders placed in June 2007.
-- Tables involved: TSQL2012 database and the Sales.Orders table

/* All other fields are irrelevant for purposes of the problem */
SELECT orderid, orderdate, custid, empid 
FROM Sales.Orders
/* WHERE clause is used to filter, YEAR(datefield) and MONTH(datefield) takes a date as an argument and returns an INT */
WHERE YEAR(orderdate) = 2007 AND MONTH(orderdate) = 6; 

-- #2. Write a query against the Sales.Orders table that returns orders placed on the last day of the month
-- Tables involved: TSQL2012 database and the Sales.Orders table

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


/*	empid, lastname, firstname, title, titleofcourtesy, birthdate, hiredate, address, city, region, postalcode, country, phone, mgrid ∈ Hr.Employees */ 

-- #3. Write a query against the HR.Employees Table that returns employees with last name containing the letter a twice or more.
-- Tables involved: TSQL2012 database and the HR.Employees table

SELECT empid, firstname, lastname
FROM HR.Employees
-- WHERE lastname like '%a%a';
WHERE len(lastname) - len(replace(lastname, 'a', '')) >= 2;

-- #4. Write a query against the Sales.OrderDetails table that returns orders with total value (quantity*unit-price) greater than 10k AND sort it by total value
-- Tables involved: TSQL2012 database and the Sales.OrderDetails table

SELECT orderid, SUM(qty * unitprice) as totalvalue
FROM Sales.OrderDetails
GROUP BY orderid
HAVING SUM(qty * unitprice) > 10000 -- WHERE keyword can't be used with aggregate functions
ORDER BY totalvalue DESC;

-- #5. Write a query against the Sales.Orders table that returns the three shipped-to countries with the highest average freight in 2007.
-- Tables involved: TSQL2012 database and the Sales.Orders table

SELECT TOP 3 shipcountry, AVG(freight) as avgfreight
FROM Sales.Orders
WHERE YEAR(orderdate) = 2007
GROUP BY shipcountry
ORDER BY avgfreight DESC;


-- #6. Write a query against the Sales.Orders table that calculates row numbers for orders based on order date ordering (using the order ID as the tiebreaker) for each customer separately.
-- Tables involved: TSQL2012 database and the Sales.Orders table

-- Partition required because "each customer is calculated separately"
SELECT custid, orderdate, orderid, ROW_NUMBER() OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS rownum
FROM Sales.Orders
ORDER BY custid, rownum -- order by precedence

-- #7. Using the HR.Employees table, figure out the SELECT statement that returns for each employee the
-- gender based on the title of courtesy. For ‘Ms. ‘ and ‘Mrs.’ return ‘Female’; for ‘Mr. ‘ return ‘Male’; and
-- in all other cases (for example, ‘Dr. ‘) return ‘Unknown’.
-- Tables involved: TSQL2012 database and the HR.Employees table

SELECT empid, firstname, lastname, titleofcourtesy, 
		CASE titleofcourtesy
			WHEN 'Ms.' THEN 'Female'
			WHEN 'Mrs.' THEN 'Female'
			WHEN 'Mr.' THEN 'Male'
			ELSE 'Unknown'
		END as gender
FROM Hr.Employees;


-- #8. Write a query against the Sales.Customers table that returns for each customer the customer ID and
-- region. Sort the rows in the output by region, having NULL marks sort last (after non-NULL values).
-- Note that the default sort behavior for NULL marks in T-SQL is to sort first (before non-NULL values).
-- Tables involved: TSQL2012 database and the Sales.Customers table

SELECT custid, region
FROM Sales.Customers
ORDER BY
CASE 
	WHEN region IS NULL THEN 1 
	ELSE 0 
END, region;
