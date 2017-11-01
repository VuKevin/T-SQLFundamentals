USE HPS;

-- 1. Write a query that returns all orders placed on the last day of activity that can be found in the
--Orders table.
--■■ Tables involved: Sales.Orders

SELECT orderid, orderdate, custid, empid
FROM Sales.Orders as SO1
WHERE SO1.orderdate = 
	(
		SELECT MAX(SO2.orderdate)
		FROM Sales.Orders as SO2
	);

/*
	Notes:
		- Because we're interested on all orders that were placed on a specific day, we will be manipulating order date such that 
		- we grab the maximum value from the orderdate column and use it to complete the first WHERE conditional clause 
*/
-- 2. Write a query that returns all orders placed by the customer(s) who placed the highest number of
--orders. Note that more than one customer might have the same number of orders.
--■■ Tables involved: Sales.Orders

SELECT custid, orderid, orderdate, empid
FROM Sales.Orders as SO1
WHERE SO1.custid = 
	(
		SELECT TOP 1 WITH TIES SO2.custid
		FROM Sales.Orders as SO2
		GROUP BY SO2.custid
		ORDER BY COUNT (*) desc
	);

/*
	Notes: Query the Sales.Orders table against itself. 
	
	The outer query wants to filter Sales.Orders by 
	identifying a customer on the condition that they placed the highest number of orders.

	The inner query find this customer and his/her ID by 1. Grouping the customer ids, and 2. Ordering it by count of 
	orders and sorting it from high to low, and 3. Picking the the the number one spot with ties

*/

-- 3. Write a query that returns employees who did not place orders on or after May 1, 2008.
--■■ Tables involved: HR.Employees and Sales.Orders

SELECT empid, FirstName, lastname
FROM HR.Employees as HRE1
WHERE HRE1.empid NOT IN
	(
		SELECT SO1.empid
		FROM Sales.Orders as SO1 
		WHERE SO1.orderdate >= '20080501'
	);

/*
	Notes: 
		Want: Find a list of employees who didn't place orders >= 20080501 
			--> This means you want to filter the HR.Employees table via empID conditional on employees who didn't ...

		Outer Query wants to filter HR.Employees by empid given condition they didn't place an order after a certain date
		Inner Query finds the customers who DID place an order by filtering Sales.Orders table  conditional on orderdate.
		
*/

-- 4. Write a query that returns countries where there are customers but not employees.
--■■ Tables involved: Sales.Customers and HR.Employees

SELECT DISTINCT SC1.country
FROM Sales.Customers as SC1
WHERE SC1.country NOT IN
	(
		SELECT HRE.country
		FROM HR.Employees as HRE
	);

/*
	Notes:
		Want: Find a list of countries conditional that country doesn't have employees

		Outer Query wants to filter Sales.Customers table ("there are customers") given condition the affiliated country doesn't have employees

		Inner Query wants to filter HR.Employees table to find employees who ARE in the given country

*/

-- 5. Write a query that returns for each customer all orders placed on the customer’s last day of activity.
--■■ Tables involved: Sales.Orders

SELECT custid, orderid, orderdate, empid
FROM Sales.Orders as O1
WHERE orderdate =
	(
		SELECT MAX(O2.orderdate)
		FROM Sales.Orders as O2
		WHERE O1.custid = O2.custid
	)
ORDER BY custid ASC;

/*
	Notes:
		Want: A list of customers, paired with all orders they placed on their last day of activity
		Outer Query: Wants this list of customers but conditional on an order date: the customers last day of activity. Draw from Sales.Orders table
		Inner Query: When the customer id's match from the tables, find the max order date.
*/

-- 6. Write a query that returns customers who placed orders in 2007 but not in 2008.
--■■ Tables involved: Sales.Customers and Sales.Orders

-- 7. Write a query that returns customers who ordered product 12.
--■■ Tables involved: Sales.Customers, Sales.Orders, and Sales.OrderDetails

-- 8. Write a query that calculates a running-total quantity for each customer and month.
--■■ Tables involved: Sales.CustOrders

SELECT custid, ordermonth, qty, 
	(
		SELECT SUM(CO2.qty) 
		FROM Sales.CustOrders as CO2
		WHERE CO2.custid = CO1.custid
		AND CO2.ordermonth <= CO1.ordermonth
	)
	as runqty
FROM Sales.CustOrders AS CO1
ORDER BY custid, ordermonth, runqty;

