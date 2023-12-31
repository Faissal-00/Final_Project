use Online_Retail
select * from Retail

--------------------------------------------------------------------------------

-- After cleaning
SELECT COUNT(*) AS total_size_after_cleaning FROM Retail;


--------------------------------------------------------------------------------

-- Check for missing values
SELECT COUNT(*) AS missing_values_count
FROM Retail
WHERE CustomerID IS NULL;

--------------------------------------------------------------------------------

-- Customers who placed the most orders on the site
SELECT TOP 5 CustomerID, COUNT(*) AS order_count
FROM Retail
GROUP BY CustomerID
ORDER BY order_count DESC;

--------------------------------------------------------------------------------

-- The highest amount spent by a single customer
SELECT TOP 1 CustomerID, SUM(UnitPrice * Quantity) AS total_spent
FROM Retail
GROUP BY CustomerID
ORDER BY total_spent DESC;

--------------------------------------------------------------------------------

-- Description of the most sold or purchased products by customers on the site
SELECT TOP 5 Description
FROM Retail
GROUP BY Description
ORDER BY SUM(Quantity) DESC;

--------------------------------------------------------------------------------

-- Convert 'InvoiceDate' column to datetime
ALTER TABLE Retail
ALTER COLUMN InvoiceDate datetime;

-- Calculate the sum of products per day
SELECT CONVERT(date, InvoiceDate) AS SaleDate, SUM(Quantity) AS TotalQuantity
FROM Retail
GROUP BY CONVERT(date, InvoiceDate);

-- Calculate the mean number of products sold per day
SELECT AVG(TotalQuantity) AS MeanProductsPerDay
FROM (
    SELECT CONVERT(date, InvoiceDate) AS SaleDate, SUM(Quantity) AS TotalQuantity
    FROM Retail
    GROUP BY CONVERT(date, InvoiceDate)
) AS T;

-- Get the top 10 days with the highest number of products sold
SELECT TOP 10 SaleDate, TotalQuantity
FROM (
    SELECT CONVERT(date, InvoiceDate) AS SaleDate, SUM(Quantity) AS TotalQuantity
    FROM Retail
    GROUP BY CONVERT(date, InvoiceDate)
) AS T
ORDER BY TotalQuantity DESC;

-------------------------------------

-- Calculate the sum of products per month
SELECT DATEFROMPARTS(YEAR(InvoiceDate), MONTH(InvoiceDate), 1) AS SaleMonth, SUM(Quantity) AS TotalQuantity
FROM Retail
GROUP BY DATEFROMPARTS(YEAR(InvoiceDate), MONTH(InvoiceDate), 1);

-- Calculate the mean number of products sold per month
SELECT AVG(TotalQuantity) AS MeanProductsPerMonth
FROM (
    SELECT DATEFROMPARTS(YEAR(InvoiceDate), MONTH(InvoiceDate), 1) AS SaleMonth, SUM(Quantity) AS TotalQuantity
    FROM Retail
    GROUP BY DATEFROMPARTS(YEAR(InvoiceDate), MONTH(InvoiceDate), 1)
) AS T;

-- Get the top 10 months with the highest number of products sold
SELECT TOP 10 SaleMonth, TotalQuantity
FROM (
    SELECT DATEFROMPARTS(YEAR(InvoiceDate), MONTH(InvoiceDate), 1) AS SaleMonth, SUM(Quantity) AS TotalQuantity
    FROM Retail
    GROUP BY DATEFROMPARTS(YEAR(InvoiceDate), MONTH(InvoiceDate), 1)
) AS T
ORDER BY TotalQuantity DESC;



--------------------------------------------------------------------------------

-- Geographical distribution of sales
SELECT Country, SUM(UnitPrice * Quantity) AS TotalAmount
FROM Retail
GROUP BY Country;

--------------------------------------------------------------------------------

-- Trend of sales over time, plotting a sales growth graph
SELECT FORMAT(InvoiceDate, 'yyyy-MM') AS sale_month, SUM(UnitPrice * Quantity) AS total_sales
FROM Retail
GROUP BY FORMAT(InvoiceDate, 'yyyy-MM')
ORDER BY sale_month;


--------------------------------------------------------------------------------

-- Seasonality of sales
SELECT DATENAME(MONTH, InvoiceDate) AS sale_month, SUM(UnitPrice * Quantity) AS total_sales
FROM Retail
GROUP BY DATENAME(MONTH, InvoiceDate), MONTH(InvoiceDate)
ORDER BY MONTH(InvoiceDate);

--------------------------------------------------------------------------------

-- Total revenue generated by the online store during a given period (e.g., year 2011)
SELECT SUM(UnitPrice * Quantity) AS total_revenue
FROM Retail
WHERE YEAR(InvoiceDate) = 2011;
