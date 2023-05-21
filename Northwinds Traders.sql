
--These are queries on the NorthWinds Traders, a global import and export company that specializes in supplying high-quality gourmet food 
--products to restaurants, cafes, and specialty food retailers around the world. ( A challenge by Maven Analytics)
 

 --TIME/PERIOD PERFORMANCE

SELECT orderDate, SUM(unitPrice * quantity) AS TotalRevenue
FROM orders AS ORS
 JOIN orderdetails AS OD
   ON ORS.orderID = OD.orderID
GROUP BY orderDate
ORDER BY 2 DESC


 --Period Performance By Year - You can select the Year or Month in the Query

With TimeIntelligence (orderDate, Year, TotalRevenue)
AS 
(
SELECT orderDate, YEAR(orderDate) AS Year, SUM(unitPrice * quantity) AS TotalRevenue
FROM orders AS ORS
 JOIN orderdetails AS OD
   ON ORS.orderID = OD.orderID
GROUP BY orderDate
--ORDER BY 1 DESC;
)

SELECT Year, TotalRevenue
FROM TimeIntelligence 
WHERE Year = 2014
ORDER BY 2 DESC


 --Period Performance By Month

With TimeIntelligence (orderDate, Year, Month, TotalRevenue)
AS 
(
SELECT orderDate, YEAR(orderDate) AS Year, MONTH(orderDate) AS Month, SUM(unitPrice * quantity) AS TotalRevenue
FROM orders AS ORS
 JOIN orderdetails AS OD
   ON ORS.orderID = OD.orderID
GROUP BY orderDate
)

SELECT Year, Month, TotalRevenue
FROM TimeIntelligence 
WHERE Year = 2014 AND MONTH = 5
ORDER BY 3 DESC



 --PRODUCT PERFORMANCE 

 --Top 10 Best Selling Products by Revenue

SELECT productName, ROUND (SUM (od.unitPrice * quantity),0) AS TotalRevenue
FROM orderdetails AS od
 JOIN products AS p
   ON od.productID = p.productID
GROUP BY productName
ORDER BY 2 DESC
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;


--Revenue Performance of the product categories and their average price

SELECT categoryName, ROUND (SUM (od.unitPrice * quantity),0) AS TotalRevenue, ROUND (AVG(p.unitPrice),1) AS AverageUnitPrice
FROM orderdetails AS od
 JOIN products AS p
   ON od.productID = p.productID
 JOIN categories AS c
   ON p.categoryID = c.categoryID
GROUP BY categoryName
ORDER BY 2 DESC
--OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;


--The quantity of products that have been discontinued per category

SELECT categoryName, ROUND (SUM (od.unitPrice * quantity),0) AS TotalRevenue, SUM (discontinued) AS Quantitydiscontinued
FROM orderdetails AS od
 JOIN products AS p
   ON od.productID = p.productID
 JOIN categories AS c
   ON p.categoryID = c.categoryID
GROUP BY categoryName
ORDER BY 2 DESC
--OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;


--SHIPPING COSTS

SELECT companyName, quantity, freight
 FROM Orders AS ORS 
  JOIN Shippers AS SH
     ON ORS.shipperID = SH.shipperID
  JOIN orderdetails AS OD
     ON OD.orderID = ORS.orderID
GROUP BY companyName, freight, quantity
ORDER BY 2 DESC


--Total Freight used on each shipping company and orders processed

SELECT companyName, SUM(quantity) AS TotalQuantity, SUM(freight) AS TotalFreightCharges
 FROM Orders AS ORS 
  JOIN Shippers AS SH
     ON ORS.shipperID = SH.shipperID
  JOIN orderdetails AS OD
     ON OD.orderID = ORS.orderID
GROUP BY companyName
ORDER BY 2 DESC


--The costs per order for each shipping company

With FreightCosts (companyName, TotalOrders, TotalFreightCharges)
AS 
(
SELECT companyName, COUNT(DISTINCT ORS.OrderID) AS TotalOrders, SUM(freight) AS TotalFreightCharges
 FROM Orders AS ORS 
  JOIN Shippers AS SH
     ON ORS.shipperID = SH.shipperID
  JOIN orderdetails AS OD
     ON OD.orderID = ORS.orderID
GROUP BY companyName
--ORDER BY 1 DESC
)
SELECT companyName, ROUND ((TotalFreightCharges/TotalOrders),0) AS FreightChargePerOrder
 FROM FreightCosts
 ORDER BY 1 DESC


 --CUSTOMER PERFORMANCE

 --Customer Revenue Performance

SELECT companyName, ROUND(SUM(unitPrice * quantity),0) AS TotalRevenue
FROM orders AS ORS
 JOIN orderdetails AS OD
    ON ORS.orderID = OD.orderID
 JOIN customers AS C
    ON C.customerID = ORS.customerID
GROUP BY companyName
ORDER BY 2 DESC


 --Customer Revenue Performance by country

SELECT country, ROUND(SUM(unitPrice * quantity),0) AS TotalRevenue
FROM orders AS ORS
 JOIN orderdetails AS OD
    ON ORS.orderID = OD.orderID
 JOIN customers AS C
    ON C.customerID = ORS.customerID
GROUP BY country
ORDER BY 2 DESC

 --Customer Performance breakdown in the USA which is the highest grossing country

SELECT companyName, SUM(quantity) AS TotalQuantity, ROUND(SUM(unitPrice * quantity),0) AS TotalRevenue
FROM orders AS ORS
 JOIN orderdetails AS OD
    ON ORS.orderID = OD.orderID
 JOIN customers AS C
    ON C.customerID = ORS.customerID
WHERE country = 'USA'
GROUP BY companyName
ORDER BY 3 DESC


