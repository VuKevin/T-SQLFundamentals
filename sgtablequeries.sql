USE HPS;
SELECT * FROM HR.Employees;

-- #1. Write a query against the Sales.Orders table that returns orders placed in June 2007.
-- Tables involved: TSQL2012 database and the Sales.Orders table

SELECT orderid, orderdate, custid, empid 
FROM Sales.Orders
WHERE YEAR(orderdate) = 2007 AND MONTH(orderdate) = 6; 

/* Notes:
	WHERE clause is used to filter, YEAR(datefield) and MONTH(datefield) takes a date as an argument and returns an INT 
*/

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

/* Notes:
	A switch statement is used to aid in filtering cases where the last day falls on the 31st, on the 30th, 
	or special cases with February and leap years.
*/

-- #3. Write a query against the HR.Employees Table that returns employees with last name containing the letter a twice or more.
-- Tables involved: TSQL2012 database and the HR.Employees table

SELECT empid, firstname, lastname
FROM HR.Employees
WHERE len(lastname) - len(replace(lastname, 'a', '')) >= 2;
-- WHERE lastname like '%a%a';

/* Notes:
	Steps include getting the length of the last name and subtracting it with the length of the last name removing all the a's
	If the resulting difference is greater or equal to two, then that employee's last name must contain at least 2 a's.
	
	Alternatively, %a%a will also match lastnames to those with at least two a's contained.-- #1. Write a query against the Sales.Orders table that returns orders placed in June 2007.
-- Tables involved: TSQL2012 database and the Sales.Orders table

SELECT orderid, orderdate, custid, empid 
FROM Sales.Orders
WHERE YEAR(orderdate) = 2007 AND MONTH(orderdate) = 6; 

SELECT orderid, orderdate. custid, empID
FROM Sales.Orders
WHERE orderdate < '20070701' and orderdate >= '20070601';

/* Notes:
	- WHERE clause is used to filter, YEAR(datefield) and MONTH(datefield) takes date as an argument and returns an INT representing the said function.
	- The second solution uses a range to filter instead.
*/

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

SELECT orderid, orderdate, custid, empID
FROM Sales.Orders
WHERE orderdate = EOMONTH(orderdate);

/* Notes:
	- A switch statement is used to aid in filtering cases where the last day falls on the 31st, on the 30th, 
	or special cases with February and leap years.
	- EOMONTH(specify_date_to_return_last_day_of_month) 
*/

-- #3. Write a query against the HR.Employees Table that returns employees with last name containing the letter a twice or more.
-- Tables involved: TSQL2012 database and the HR.Employees table

SELECT empid, firstname, lastname
FROM HR.Employees
WHERE len(lastname) - len(replace(lastname, 'a', '')) >= 2;

SELECT empid, firstname, lastname
FROM HR.Employees
WHERE lastname like '%a%a%';

/* Notes:
	Steps include getting the length of the last name and subtracting it with the length of the last name removing all the a's
	If the resulting difference is greater or equal to two, then that employee's last name must contain at least 2 a's.
	
	Alternatively, %a%a% will also match lastnames to those with at least two a's contained as % acts as a wild card

	%  Any string of zero or more characters.
	_  Any single character.
   [ ] Any single character within the specified range (for example, [a-f]) or set (for example, [abcdef]).
   [^] Any single character not within the specified range (for example, [^a - f]) or set (for example, [^abcdef]).

*/

-- #4*. Write a query against the Sales.OrderDetails table that returns orders with total value (quantity*unit-price) greater than 10k AND sort it by total value
-- Tables involved: TSQL2012 database and the Sales.OrderDetails table

SELECT orderid, SUM(qty * unitprice) as totalvalue
FROM Sales.OrderDetails
GROUP BY orderid
HAVING SUM(qty * unitprice) > 10000 
ORDER BY totalvalue DESC;

/* Notes:
	HAVING is used in place of WHERE because WHERE is unable to handle aggregate functions. 
	In this case, we took SUM(qty*unitprice).
	
	HAVING Syntax:
	SELECT column_name(s)
	FROM table_name
	WHERE condition -- optional
	GROUP BY column_names(s)
	HAVING condition
	ORDER BY column_names(s);
	
*/

-- #5. Write a query against the Sales.Orders table that returns the three shipped-to countries with the highest average freight in 2007.
-- Tables involved: TSQL2012 database and the Sales.Orders table

SELECT TOP 3 shipcountry, AVG(freight) as avgfreight
FROM Sales.Orders
WHERE YEAR(orderdate) = 2007
GROUP BY shipcountry
ORDER BY avgfreight DESC;

SELECT shipcountry, AVG(freight) as avgfreight
FROM Sales.Orders
WHERE YEAR(orderdate) = 2007
GROUP BY shipcountry
ORDER BY avgfreight DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;

SELECT TOP 3 shipcountry, AVG(freight) as avgfreight
FROM Sales.Orders
WHERE orderdate < '20080101' AND orderdate >= '20070101'
GROUP BY shipcountry
ORDER BY avgfreight DESC;

/* Notes:
	SELECT TOP num clause specifies the number of records to return that are of interest.
	AVG() returns the average value of a numeric column
*/

-- #6. Write a query against the Sales.Orders table that calculates row numbers for orders based on order date ordering (using the order ID as the tiebreaker) for each customer separately.
-- Tables involved: TSQL2012 database and the Sales.Orders table

SELECT custid, orderdate, orderid, ROW_NUMBER() OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS rownum
FROM Sales.Orders
ORDER BY custid, rownum 

/* Notes:
	ROW_NUMBER() OVER(PARTITION BY column_name ORDER BY column_name, column_name)
	Note: ROW_NUMBER() and RANK() are similar except RANK provides the same numeric value for ties.
*/

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

SELECT empid, firstname, lastname, titleofcourtesy, 
		CASE 
			WHEN titleofcourtesy = 'Ms.' THEN 'Female'
			WHEN titleofcourtesy = 'Mrs.' THEN 'Female'
			WHEN titleofcourtesy = 'Mr.' THEN 'Male'
			ELSE 'Unknown'
		END as gender
FROM Hr.Employees;

SELECT empid, firstname, lastname, titleofcourtesy, 
		CASE 
			WHEN titleofcourtesy in('Ms.', 'Mrs.') THEN 'Female'
			WHEN titleofcourtesy = 'Mr.' THEN 'Male'
			ELSE 'Unknown'
		END as gender
FROM Hr.Employees;

/* Notes:
	It is possible, as shown here, to use a switch statement in the formation of a new field (gender in this case)
*/

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

SELECT custid, region
FROM Sales.Customers
ORDER BY
CASE 
	WHEN region IS NULL THEN 2 
	ELSE 1 
END, region;
*/

-- #4. Write a query against the Sales.OrderDetails table that returns orders with total value (quantity*unit-price) greater than 10k AND sort it by total value
-- Tables involved: TSQL2012 database and the Sales.OrderDetails table

SELECT orderid, SUM(qty * unitprice) as totalvalue
FROM Sales.OrderDetails
GROUP BY orderid
HAVING SUM(qty * unitprice) > 10000 
ORDER BY totalvalue DESC;

/* Notes:
	HAVING is used in place of WHERE because WHERE is unable to handle aggregate functions. 
	In this case, we took SUM(qty*unitprice).
	
	HAVING Syntax:
	SELECT column_name(s)
	FROM table_name
	WHERE condition -- optional
	GROUP BY column_names(s)
	HAVING condition
	ORDER BY column_names(s);
	
*/

-- #5. Write a query against the Sales.Orders table that returns the three shipped-to countries with the highest average freight in 2007.
-- Tables involved: TSQL2012 database and the Sales.Orders table

SELECT TOP 3 shipcountry, AVG(freight) as avgfreight
FROM Sales.Orders
WHERE YEAR(orderdate) = 2007
GROUP BY shipcountry
ORDER BY avgfreight DESC;

/* Notes:
	SELECT TOP num clause specifies the number of records to return that are of interest.
	AVG() returns the average value of a numeric column
*/

-- #6. Write a query against the Sales.Orders table that calculates row numbers for orders based on order date ordering (using the order ID as the tiebreaker) for each customer separately.
-- Tables involved: TSQL2012 database and the Sales.Orders table

SELECT custid, orderdate, orderid, ROW_NUMBER() OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS rownum
FROM Sales.Orders
ORDER BY custid, rownum 

/* Notes:
	ROW_NUMBER() OVER(PARTITION BY column_name ORDER BY column_name, column_name)
	Note: ROW_NUMBER() and RANK() are similar except RANK provides the same numeric value for ties.
*/

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

/* Notes:
	It is possible, as shown here, to use a switch statement in the formation of a new field (gender in this case)
*/

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
