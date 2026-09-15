USE online_retail_analysis;
SELECT COUNT(DISTINCT CustomerID) AS Customers
FROM retail_clean;

SELECT
	COUNT(DISTINCT InvoiceNo) AS Unique_Transactions,
    COUNT(DISTINCT StockCode) AS Products,
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM retail_clean;

SELECT
	CustomerID,
    COUNT(DISTINCT InvoiceNo) AS Unique_Transactions,
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM retail_clean
GROUP BY CustomerID;

SELECT Customer_Type,
	COUNT(*) AS Customers
FROM (
	SELECT
		CustomerID,
		CASE
			WHEN COUNT(DISTINCT InvoiceNo) = 1 THEN 'One-Time'
			ELSE 'Repeat'
		END AS Customer_Type
	FROM retail_clean
	GROUP BY CustomerID
) AS Customer_Summary
GROUP BY Customer_Type;

SELECT
	CustomerID,
    COUNT(DISTINCT InvoiceNo) AS Unique_Transactions,
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM retail_clean
GROUP BY CustomerID
ORDER BY Total_Revenue DESC
LIMIT 10;

SELECT
	InvoiceNo,
    InvoiceDate,
    Quantity,
    UnitPrice,
    Revenue
FROM retail_clean
WHERE CustomerID = 16446;

SELECT
	COUNT(DISTINCT CustomerID) AS Customers,
    ROUND(AVG(Customer_Revenue), 2) AS Avg_Revenue,
    ROUND(MIN(Customer_Revenue), 2) AS Min_Revenue,
    ROUND(MAX(Customer_Revenue), 2) AS Max_Revenue,
    ROUND(STDDEV(Customer_Revenue), 2) AS Std_Revenue
FROM (
	SELECT
		CustomerID,
        SUM(Revenue) AS Customer_Revenue
	FROM retail_clean
    GROUP BY CustomerID
) AS customer_summary;

WITH customer_revenue AS (
	SELECT
		CustomerID,
        SUM(Revenue) AS Customer_Revenue
	FROM retail_clean
    GROUP BY CustomerID
),
quartiles AS (
	SELECT
		CustomerID,
        Customer_Revenue,
        NTILE(4) OVER (ORDER BY Customer_Revenue) AS Quartile
	FROM customer_revenue
)
SELECT
	Quartile,
    COUNT(*) AS Customers,
    ROUND(SUM(Customer_Revenue), 2) AS Total_Revenue,
	ROUND(AVG(Customer_Revenue), 2) AS Avg_Revenue,
    ROUND(MIN(Customer_Revenue), 2) AS Min_Revenue,
    ROUND(MAX(Customer_Revenue), 2) AS Max_Revenue
FROM quartiles
GROUP BY Quartile
ORDER BY Quartile;