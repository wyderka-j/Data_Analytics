
/**********************************************************************/
/* SQL Queries  */
/**********************************************************************/

/**********************************************************************/
/* Credit to Schema : https://github.com/AndrejPHP/w3schools-database */
/**********************************************************************/
/* Run w3schools.sql to set up database, tables and data*/

/*
----Schema----
Customers (CustomerID, CustomerName, ContactName, Address, City, PostalCode, Country)
Categories (CategoryID,CategoryName, Description)
Employees (EmployeeID, LastName, FirstName, BirthDate, Photo, Notes)
OrderDetails(OrderDetailID, OrderID, ProductID, Quantity)
Orders (OrderID, CustomerID, EmployeeID, OrderDate, ShipperID)
Products(ProductID, ProductName, SupplierID, CategoryID, Unit, Price)
Shippers (ShipperID, ShipperName, Phone)
*/

USE w3schools;

-- 1. Select customer name together with each order the customer made
SELECT c.CustomerName, o.OrderID
FROM customers AS c
JOIN orders AS o
ON c.CustomerID = o.CustomerID;

-- 2. Select order id together with name of employee who handled the order
SELECT o.OrderID, e.EmployeeID, e.FirstName, e.LastName
FROM orders AS o
JOIN employees AS e
ON o.EmployeeID = e.EmployeeID;

-- 3. Select customers who did not placed any order yet
SELECT c.CustomerID, c.CustomerName
FROM customers AS c
LEFT JOIN orders AS o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;

-- 4. Select order id together with the name of products
SELECT o.OrderID, p.ProductID, p.ProductName
FROM orders AS o
JOIN order_details AS od ON o.OrderID = od.OrderID
JOIN products AS p ON od.ProductID = p.ProductID
ORDER BY o.OrderID;

-- 5. Select products that no one bought
SELECT p.ProductID, p.ProductName, od.OrderID
FROM products p
LEFT JOIN order_details od ON p.ProductID = od.ProductID
WHERE od.OrderID IS NULL;

-- 6. Select customer together with the products that he bought
SELECT c.CustomerID, c.CustomerName, p.ProductName
FROM customers c
JOIN orders o ON o.CustomerID = c.CustomerID
JOIN order_details od ON od.OrderID = o.OrderID
JOIN products p ON p.ProductID = od.ProductID
ORDER BY c.CustomerID, p.ProductName ASC;

-- 7. Select product names together with the name of corresponding category
SELECT p.ProductID, p.ProductName, c.CategoryName
FROM products p
JOIN categories c
ON p.CategoryID = c.CategoryID;

-- 8. Select orders together with the name of the shipping company
SELECT o.OrderID, o.CustomerID, o.EmployeeID, o.OrderDate, shp.ShipperName
FROM orders o
JOIN shippers shp
ON o.ShipperID = shp.ShipperID
ORDER BY o.OrderID;

-- 9. Select customers with id greater than 50 together with each order they made
SELECT c.CustomerID, c.CustomerName, o.OrderID
FROM customers c
JOIN orders o
ON c.CustomerID = o.CustomerID
WHERE c.CustomerID > 50;

-- 10. Select employees together with orders with order id greater than 10400
SELECT o.OrderID, e.EmployeeID, e.FirstName, e.LastName
FROM orders o
JOIN employees e ON o.EmployeeID = e.EmployeeID
WHERE o.OrderID > 10400
ORDER BY o.OrderID;

-- 11. Select the most expensive product
SELECT ProductID,ProductName,Price
FROM products
ORDER BY Price DESC
LIMIT 1;

-- 12. Select the second most expensive product
SELECT ProductID,ProductName,Price
FROM products
ORDER BY Price DESC
LIMIT 1 OFFSET 1;

-- 13. Select name and price of each product, sort the result by price in decreasing order
SELECT ProductID,ProductName,Price
FROM products
ORDER BY Price DESC;

-- 14. Select 5 most expensive products
SELECT ProductID,ProductName,Price
FROM products
ORDER BY Price DESC
LIMIT 5;

-- 15. Select 5 most expensive products without the most expensive (in final 4 products)
SELECT ProductID,ProductName,Price
FROM products
ORDER BY Price DESC
LIMIT 4 OFFSET 1;

-- 16. Select name of the cheapest product (only name) without using LIMIT and OFFSET
SELECT ProductName
FROM products
WHERE Price IN (
	SELECT MIN(Price) FROM products
);

-- 17. Select employees with LastName that starts with 'D'
SELECT EmployeeID, LastName, FirstName
FROM employees
WHERE LastName LIKE 'D%';

-- 18.  Select number of employees with LastName that starts with 'D'
SELECT COUNT(EmployeeID)
FROM employees
WHERE LastName LIKE 'D%';

-- 19 Select Customers with LastName that starts with 'D'
SELECT CustomerName, SUBSTRING_INDEX(CustomerName," ",1) AS firstName, SUBSTRING_INDEX(CustomerName," ",-1) AS lastName
FROM customers
WHERE  SUBSTRING_INDEX(CustomerName," ",-1) LIKE 'D%';

-- 20. Select customer name together with the number of orders made by the corresponding customer sort the result by number of orders in dec order
SELECT c.CustomerID, c.CustomerName, COUNT(*) AS 'TotalOder'
FROM customers c
JOIN Orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
ORDER BY 3 DESC, 1 ASC;

-- 21. Add up the price of all products
SELECT SUM(Price)
FROM products;

-- 22. Select orderID together with the total price of that Order, order the result by total price of order in increasing order
SELECT od.OrderID, SUM((od.Quantity * p.Price)) AS TotalValueOfOrder
FROM order_details od
JOIN products p ON p.ProductID = od.ProductID
GROUP BY 1
ORDER BY 2 ASC;

-- 23. Select customer who spend the most money
SELECT c.CustomerID, c.CustomerName, SUM(od.Quantity * p.Price) AS TotalSpending
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
JOIN order_details od ON o.OrderID = od.OrderID
JOIN products p ON p.ProductID = od.ProductID
GROUP BY c.CustomerID
ORDER BY 3 DESC
LIMIT 1;

-- 24. Select customer who spend the most money and lives in Canada
SELECT c.CustomerID, c.CustomerName, SUM(od.Quantity * p.Price) AS TotalSpending, c.Country
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
JOIN order_details od ON o.OrderID = od.OrderID
JOIN products p ON p.ProductID = od.ProductID
WHERE c.Country LIKE 'Canada'
GROUP BY c.CustomerID
ORDER BY 3 DESC
LIMIT 1;

-- 25. Select customer who spend the second most money*/
SELECT c.CustomerID, c.CustomerName, SUM(od.Quantity * p.Price) AS TotalSpending
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
JOIN order_details od ON o.OrderID = od.OrderID
JOIN products p ON p.ProductID = od.ProductID
GROUP BY c.CustomerID
ORDER BY 3 DESC
LIMIT 1 OFFSET 1;

-- 26. Select shipper together with the total price of proceed orders
SELECT o.ShipperID, shp.ShipperName, SUM(od.Quantity * p.Price) AS TotalValueOfOrder
FROM orders o
JOIN order_details od ON o.OrderID = od.OrderID
JOIN products p ON p.ProductID = od.ProductID
JOIN shippers shp ON shp.ShipperID = o.ShipperID
GROUP BY 1
ORDER BY 2;