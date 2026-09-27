SELECT
    a.artistid,
    a.name AS artist_name,
    al.albumid,
    al.title AS album_title
FROM artist a
JOIN album al
    ON a.artistid = al.artistid
LIMIT 10;



SELECT
    al.albumid,
    al.title AS album_title,
    t.trackid,
    t.name AS track_name
FROM album al
JOIN track t
    ON al.albumid = t.albumid
LIMIT 10;


SELECT
    t.trackid,
    t.name AS track_name,
    il.invoicelineid,
    il.invoiceid,
    il.quantity,
    il.unitprice
FROM track t
JOIN invoiceline il
    ON t.trackid = il.trackid
LIMIT 10;



SELECT
    il.invoicelineid,
    il.invoiceid,
    i.invoicedate,
    i.customerid,
    c.firstname,
    c.lastname,
    il.unitprice,
    il.quantity
FROM invoiceline il
JOIN invoice i
    ON il.invoiceid = i.invoiceid
JOIN customer c
    ON i.customerid = c.customerid
LIMIT 10;




SELECT
    ROUND(SUM(unitprice * quantity), 2) AS total_revenue
FROM invoiceline;

SELECT COUNT(*) AS Total_Customers
FROM customer; 

SELECT SUM(Total) AS Total_Sales
FROM invoice;


SELECT AVG(Total) AS Average_Invoice_Value
FROM invoice;
-- Coustomers and Sales Analysis .. 


-- Task 1: Total Customers
SELECT COUNT(*) AS Total_Customers
FROM customer;


-- Task 2: Total Sales
SELECT SUM(Total) AS Total_Sales
FROM invoice;


-- Task 3: Average Invoice Value
SELECT AVG(Total) AS Average_Invoice_Value
FROM invoice;


-- Task 4: Highest Invoice Value
SELECT MAX(Total) AS Highest_Invoice
FROM invoice;


-- Task 5: Lowest Invoice Value
SELECT MIN(Total) AS Lowest_Invoice
FROM invoice;


-- Task 6: Total Number of Invoices
SELECT COUNT(*) AS Total_Invoices
FROM invoice;


-- Task 7: Sales by Country
SELECT BillingCountry,
       SUM(Total) AS Total_Sales
FROM invoice
GROUP BY BillingCountry
ORDER BY Total_Sales DESC;


-- Task 8: Customers by Country
SELECT Country,
       COUNT(*) AS Customer_Count
FROM customer
GROUP BY Country
ORDER BY Customer_Count DESC;


-- Task 9: Top 10 Customers by Spending
SELECT 
    c.CustomerId,
    c.FirstName,
    c.LastName,
    SUM(i.Total) AS Total_Spending
FROM customer c
JOIN invoice i
    ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName
ORDER BY Total_Spending DESC
LIMIT 10;


-- Task 10: Top 10 Invoices
SELECT InvoiceId,
       CustomerId,
       InvoiceDate,
       Total
FROM invoice
ORDER BY Total DESC
LIMIT 10;


-- Advanced Business Analysis  
-- Task 11: Sales by Year
SELECT YEAR(InvoiceDate) AS Sales_Year,
       SUM(Total) AS Total_Sales
FROM invoice
GROUP BY YEAR(InvoiceDate)
ORDER BY Sales_Year;


-- Task 12: Sales by Month
SELECT MONTH(InvoiceDate) AS Sales_Month,
       SUM(Total) AS Total_Sales
FROM invoice
GROUP BY MONTH(InvoiceDate)
ORDER BY Sales_Month;


-- Task 13: Total Tracks
SELECT COUNT(*) AS Total_Tracks
FROM track;


-- Task 14: Total Artists
SELECT COUNT(*) AS Total_Artists
FROM artist;


-- Task 15: Total Albums
SELECT COUNT(*) AS Total_Albums
FROM album;


-- Task 16: Tracks by Genre
SELECT g.Name AS Genre,
       COUNT(t.TrackId) AS Track_Count
FROM genre g
JOIN track t
    ON g.GenreId = t.GenreId
GROUP BY g.GenreId, g.Name
ORDER BY Track_Count DESC;


-- Task 17: Top 10 Most Expensive Tracks
SELECT Name,
       UnitPrice
FROM track
ORDER BY UnitPrice DESC
LIMIT 10;


-- Task 18: Top 10 Longest Tracks
SELECT Name,
       Milliseconds
FROM track
ORDER BY Milliseconds DESC
LIMIT 10;


-- Task 19: Sales by Customer
SELECT 
    c.CustomerId,
    c.FirstName,
    c.LastName,
    SUM(i.Total) AS Total_Spending
FROM customer c
JOIN invoice i
    ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName
ORDER BY Total_Spending DESC;


-- Task 20: Number of Invoices per Customer
SELECT 
    c.CustomerId,
    c.FirstName,
    c.LastName,
    COUNT(i.InvoiceId) AS Invoice_Count
FROM customer c
JOIN invoice i
    ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName
ORDER BY Invoice_Count DESC;


-- Advanced Business Analysis   
-- JOIN Analysis — Customer + Invoice  
SELECT
    c.CustomerId,
    CONCAT(c.FirstName, ' ', c.LastName) AS Customer_Name,
    COUNT(i.InvoiceId) AS Total_Invoices,
    SUM(i.Total) AS Total_Spending
FROM customer c
JOIN invoice i
    ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName
ORDER BY Total_Spending DESC;


-- Top Artists by Number of Tracks  
SELECT
    ar.ArtistId,
    ar.Name AS Artist,
    COUNT(t.TrackId) AS Track_Count
FROM artist ar
JOIN album al
    ON ar.ArtistId = al.ArtistId
JOIN track t
    ON al.AlbumId = t.AlbumId
GROUP BY ar.ArtistId, ar.Name
ORDER BY Track_Count DESC
LIMIT 10;

-- Top Tracks by Revenue
SELECT
    t.TrackId,
    t.Name AS Track,
    SUM(il.UnitPrice * il.Quantity) AS Revenue
FROM track t
JOIN invoiceline il
    ON t.TrackId = il.TrackId
GROUP BY t.TrackId, t.Name
ORDER BY Revenue DESC
LIMIT 10;


-- Revenue by Genre  
SELECT
    g.Name AS Genre,
    SUM(il.UnitPrice * il.Quantity) AS Revenue
FROM genre g
JOIN track t
    ON g.GenreId = t.GenreId
JOIN invoiceline il
    ON t.TrackId = il.TrackId
GROUP BY g.GenreId, g.Name
ORDER BY Revenue DESC;

-- Customer Segmentation — CASE WHEN  
SELECT
    c.CustomerId,
    CONCAT(c.FirstName, ' ', c.LastName) AS Customer_Name,
    SUM(i.Total) AS Total_Spending,
    CASE
        WHEN SUM(i.Total) >= 40 THEN 'High Value'
        WHEN SUM(i.Total) >= 20 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Customer_Segment
FROM customer c
JOIN invoice i
    ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName
ORDER BY Total_Spending DESC;

-- Customer Ranking — Window Function 
SELECT
    CustomerId,
    Customer_Name,
    Total_Spending,
    RANK() OVER (ORDER BY Total_Spending DESC) AS Customer_Rank
FROM (
    SELECT
        c.CustomerId,
        CONCAT(c.FirstName, ' ', c.LastName) AS Customer_Name,
        SUM(i.Total) AS Total_Spending
    FROM customer c
    JOIN invoice i
        ON c.CustomerId = i.CustomerId
    GROUP BY c.CustomerId, c.FirstName, c.LastName
) AS Customer_Sales;

-- Monthly Sales + Running Total
WITH Monthly_Sales AS (
    SELECT
        DATE_FORMAT(InvoiceDate, '%Y-%m') AS Sales_Month,
        SUM(Total) AS Monthly_Sales
    FROM invoice
    GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
)
SELECT
    Sales_Month,
    Monthly_Sales,
    SUM(Monthly_Sales) OVER (
        ORDER BY Sales_Month
    ) AS Running_Total
FROM Monthly_Sales
ORDER BY Sales_Month;

-- Top 3 Customers per Country  
WITH Customer_Sales AS (
    SELECT
        c.Country,
        c.CustomerId,
        CONCAT(c.FirstName, ' ', c.LastName) AS Customer_Name,
        SUM(i.Total) AS Total_Spending
    FROM customer c
    JOIN invoice i
        ON c.CustomerId = i.CustomerId
    GROUP BY
        c.Country,
        c.CustomerId,
        c.FirstName,
        c.LastName
),
Ranked_Customers AS (
    SELECT
        Country,
        CustomerId,
        Customer_Name,
        Total_Spending,
        ROW_NUMBER() OVER (
            PARTITION BY Country
            ORDER BY Total_Spending DESC
        ) AS Country_Rank
    FROM Customer_Sales
)
SELECT
    Country,
    CustomerId,
    Customer_Name,
    Total_Spending,
    Country_Rank
FROM Ranked_Customers
WHERE Country_Rank <= 3
ORDER BY Country, Country_Rank;


-- Customer Spending Above Average  
SELECT
    c.CustomerId,
    CONCAT(c.FirstName, ' ', c.LastName) AS Customer_Name,
    SUM(i.Total) AS Total_Spending
FROM customer c
JOIN invoice i
    ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName
HAVING SUM(i.Total) > (
    SELECT AVG(Customer_Total)
    FROM (
        SELECT
            SUM(Total) AS Customer_Total
        FROM invoice
        GROUP BY CustomerId
    ) AS Customer_Averages
)
ORDER BY Total_Spending DESC;


-- Final Business Summary
SELECT
    COUNT(DISTINCT CustomerId) AS Total_Customers,
    COUNT(InvoiceId) AS Total_Invoices,
    SUM(Total) AS Total_Revenue,
    AVG(Total) AS Average_Invoice_Value,
    MAX(Total) AS Highest_Invoice,
    MIN(Total) AS Lowest_Invoice
FROM invoice;