SQL queries

- Explore the dataset

1. Classify customers based on their sales volumes (Grade A-D)
SELECT c.CompanyName,
SUM((od.Quantity * od.UnitPrice)) AS Total,
CASE
WHEN SUM((od.Quantity * od.UnitPrice)) >= 30000 THEN 'A'
WHEN SUM((od.Quantity * od.UnitPrice)) < 30000 and sum((od.Quantity * od.UnitPrice)) >=
20000 THEN 'B'
ELSE 'C'
END AS Customer_Grade
FROM Customers c
INNER JOIN Orders o
ON c.CustomerID = o.CustomerID
inner join
`Order Details` od
ON o.OrderID = od.OrderID
INNER JOIN
Products p
ON od.ProductID = p.ProductID
GROUP BY  c.CompanyName
ORDER BY Total DESC

2. Top 10 purchased products based on units sold for each product sorted in a descent order
SELECT TOP 10 p.ProductName, SUM(od.Quantity) AS `Total Units Sold`
FROM
Orders o
inner join
`Order Details` od
ON o.OrderID = od.OrderID
INNER JOIN
Products p
ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY `Total Units Sold` DESC



- Extract data and export into csv files. Then upload into Tableau.

1. Extract information about company's name, location, data, total sale, etc.

mSELECT c.CompanyName, c.City, c.Country, CONVERT(o.OrderDate, DATE) AS Order_Date, od.Quantity, od.UnitPrice, 
p.ProductName, ct.CategoryName
FROM
Customers c 
INNER JOIN
Orders o
ON
c.CustomerID = o.CustomerID
INNER JOIN
`Order Details` od
ON o.OrderID = od.OrderID
INNER JOIN
Products p
ON od.ProductID = p.ProductID
INNER JOIN
Categories ct
ON p.CategoryID = ct.CategoryID



- Extract total sale by each companies and classified them into groups.

SELECT c.CompanyName, SUM((od.Quantity * od.UnitPrice)) AS Totalsale,
CASE 
WHEN SUM((od.Quantity * od.UnitPrice)) >= 40000 THEN 'A'
WHEN SUM((od.Quantity * od.UnitPrice)) < 40000 
AND SUM((od.Quantity * od.UnitPrice)) >= 20000 THEN 'B'
WHEN SUM((od.Quantity * od.UnitPrice)) < 20000
AND SUM((od.Quantity * od.UnitPrice)) >= 10000 THEN 'C'
ELSE 'D'
End AS `Customer Grade`
FROM Customers c
INNER JOIN Orders o
On c.CustomerID = o.CustomerID
INNER JOIN
`Order Details` od
ON o.OrderID = od.OrderID
INNER JOIN
Products p
ON od.ProductID = p.ProductID
GROUP BY c.CompanyName
ORDER BY Totalsale DESC
