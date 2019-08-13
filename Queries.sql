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

3. Sales by Year. Join orders table and price table(subquery), then group by shipped date in years
select distinct date(o.ShippedDate) as ShippedDate, 
    o.OrderID, 
    od.Subtotal, 
    year(o.ShippedDate) as Year
from Orders o
inner join
( select distinct OrderID, 
        format(sum(UnitPrice * Quantity * (1 - Discount)), 2) as total
    from `order details`
    group by OrderID    
) od on o.OrderID = od.OrderID
where o.ShippedDate is not null
    and o.ShippedDate between date('1996-12-24') and date('1997-09-30')
order by ShippedDate

4. Sales by Category. Join orders, products and categories tables. taking account the discount for the total sales in this query, 
then group by categoryID, followed by productname and totalsales.
select distinct a.CategoryID, 
    a.CategoryName,  
    b.ProductName, 
    sum(round(y.UnitPrice * y.Quantity * (1 - y.Discount), 2)) as Totalsales
from `Order Details` od
inner join Orders d on d.OrderID = od.OrderID
inner join Products b on b.ProductID = od.ProductID
inner join Categories a on a.CategoryID = b.CategoryID
where d.OrderDate between date('1997/1/1') and date('1997/12/31')
group by a.CategoryID, a.CategoryName, b.ProductName
order by a.CategoryName, b.ProductName, Totalsales;

- Extract data and export into csv files. Then upload into Tableau.

1. Extract information about company's name, location, data, total sale, etc.

SELECT c.CompanyName, c.City, c.Country, CONVERT(o.OrderDate, DATE) AS Order_Date, od.Quantity, od.UnitPrice, 
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
