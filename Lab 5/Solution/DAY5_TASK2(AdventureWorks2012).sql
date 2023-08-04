--DAY5_TASK2(AdventureWorks2012)
USE AdventureWorks2012

--1
SELECT S.SalesOrderID, S.ShipDate
FROM Sales.SalesOrderHeader S
WHERE S.ShipDate > '2002-07-28' AND ShipDate < '2014-07-29'

--2
SELECT ProductID, [Name]
FROM Production.Product
WHERE StandardCost < 110

--3
SELECT ProductID, [Name]
FROM Production.Product
WHERE [Weight] IS NULL

--4
SELECT *
FROM Production.Product
WHERE Color IN ('Silver', 'Black', 'Red')

--5
SELECT *
FROM Production.Product
WHERE Name LIKE 'B%'

--6
UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3

SELECT *
FROM Production.ProductDescription
WHERE Description LIKE '%_%' 

--7
SELECT SUM(TotalDue) AS [TotalDue Sum], OrderDate
FROM Sales.SalesOrderHeader
WHERE OrderDate > '2001-07-01' AND OrderDate < '2014-07-31'
GROUP BY OrderDate

--8
SELECT DISTINCT HireDate
FROM HumanResources.Employee

--9
SELECT AVG(DISTINCT ListPrice) AS [ListPrice Avg.]
FROM Production.Product

--10
SELECT CONCAT('The ', [Name], ' is only! ', ListPrice) AS ProductInfo
FROM Production.Product
WHERE ListPrice between 100 AND 120
ORDER BY ListPrice

-- 11
-- A
SELECT rowguid, [Name], SalesPersonID, Demographics
INTO store_Archive
FROM Sales.Store
-- B
SELECT rowguid, [Name], SalesPersonID, Demographics
FROM Sales.Store

--12
SELECT CONVERT(varchar, GETDATE(), 101) AS 'MM/DD/YYYY'
UNION
SELECT CONVERT(varchar, GETDATE(), 102) AS 'YYYY.MM.DD'
UNION
SELECT CONVERT(varchar, GETDATE(), 103) AS 'DD/MM/YYYY'
UNION
SELECT FORMAT(GETDATE(), 'MMMM dd, yyyy') AS 'Month DD, YYYY'
UNION
SELECT FORMAT(GETDATE(), 'yyyy/MM/dd') AS 'YYYY/MM/DD'