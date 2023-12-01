/* Q: Display yearly value of orders for each company. Do not include results of the companies that ordered less than $3000/y. Include country of customer */

SELECT c.CompanyName ,c.Country ,YEAR(o.OrderDate) AS ORDERyear, SUM(od.UnitPrice * od.Quantity) AS 'Yearly orders value' 
FROM customers c
INNER JOIN orders o ON c.CustomerID = o.CustomerID 
INNER JOIN order_details od ON Od.OrderID = o.OrderID 
GROUP BY orderyear, c.CompanyName, c.Country
HAVING SUM(od.UnitPrice * od.Quantity) >= 3000
ORDER BY 1


/* Write a query to get the most expensive and least expensive products. Please include name and unit price. */

SELECT p.ProductName ,p.UnitPrice FROM products p 
WHERE p.UnitPrice IN (SELECT min(UnitPrice) FROM products)
OR p.UnitPrice IN (SELECT max(UnitPrice)  FROM products)

/* Create a report that shows the Company Names and name of contact person from customers that have no fax number. */

SELECT customers.CompanyName , customers.ContactName  FROM customers 
WHERE customers.Fax IS NULL 

/* Create a report that shows the SupplierID, ProductName, CompanyName from all product Supplied by Tokyo Traders or Norske Meierier sorted by the supplier ID */

SELECT s.SupplierID, s.CompanyName , p.ProductName 
FROM suppliers s 
INNER JOIN products p ON s.SupplierID = p.SupplierID  
WHERE s.CompanyName LIKE '%Tokyo Traders%' 
OR s.CompanyName LIKE '%Norske Meierier%'
ORDER BY 1

/* Create a view named SupplierInfo that shows the SupplierID, Company Name, Address, City, Country, Phone and offered product names from the suppliers and products table. */

CREATE VIEW SupplierInfo AS 
SELECT s.SupplierID, s.CompanyName, s.Address , s.City , s.Country, s.Phone, p.ProductName 
FROM suppliers s 
INNER JOIN products p ON s.supplierid = p.supplierid

/* Rank customers handled by employee Mr. King based on their sales volumes (Top for >20K, Average, Bad below 10K) */

SELECT c.CompanyName AS Company, SUM(od.Quantity * od.UnitPrice) AS Total_Sale, 
CASE 
	WHEN SUM(od.Quantity * od.UnitPrice) >= 20000 THEN 'Top'
	WHEN SUM(od.Quantity * od.UnitPrice) >= 10000 AND SUM((od.Quantity * od.UnitPrice)) < 20000 THEN 'Average'
	ELSE 'Bad'
END AS Rating
FROM customers c
INNER JOIN orders o ON c.CustomerID = o.CustomerID 
INNER JOIN employees e ON e.EmployeeID = o.EmployeeID
INNER JOIN order_details od ON od.OrderID = o.OrderID 
WHERE e.LastName = 'King'
GROUP BY 1
ORDER BY 2 DESC

/* With use of CTE check average product price for each company orders from 1995.  */

WITH ordersbydate AS
(SELECT c.CompanyName, o.OrderDate, od.UnitPrice
FROM customers c JOIN orders o ON o.customerid = c.customerid
JOIN order_details od on od.orderid = o.orderid
WHERE o.orderdate like "1995%")

SELECT companyname Company, round(avg(unitprice),2) 'Average price' FROM ordersbydate
GROUP BY companyname 
ORDER BY 1 ASC 

/* Using window function check average ordered product price for every company by year. */

SELECT c.CompanyName, o.OrderDate, od.UnitPrice, 
avg(od.UnitPrice) OVER (PARTITION BY c.CustomerID, YEAR(o.OrderDate)) 'Average product prive'
FROM customers c
JOIN orders o ON o.customerid = c.customerid
JOIN order_details od on od.orderid = o.orderid
ORDER BY 1,2 

