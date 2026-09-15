SELECT
	DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month,
    COUNT(DISTINCT CustomerID) AS Customers,
    COUNT(DISTINCT InvoiceNo) AS Transactions,
    ROUND(SUM(Revenue), 2) AS Revenue,
    ROUND(SUM(Revenue) / COUNT(DISTINCT InvoiceNo),
		2
	) AS AOV
FROM retail_clean
GROUP BY Month
ORDER BY Month;

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

SELECT
	Country,
    COUNT(DISTINCT CustomerID) AS Customers,
    COUNT(DISTINCT InvoiceNo) AS Transactions,
    ROUND(SUM(Revenue), 2) AS Total_Revenue,
    ROUND(
		SUM(Revenue) / COUNT(DISTINCT CustomerID), 2
	) AS Revenue_per_Customer
FROM retail_clean
GROUP BY Country
ORDER BY Revenue_Per_Customer DESC;

SELECT
	COUNT(DISTINCT CustomerID) AS Total_Customers,
    COUNT(DISTINCT InvoiceNo) AS Total_Transactions,
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM retail_clean;

SELECT
	COUNT(DISTINCT CustomerID) AS Total_Customers,
    COUNT(DISTINCT InvoiceNo) AS Total_Transactions,
    ROUND(SUM(Revenue), 2) AS Total_Revenue,
    ROUND(
    AVG(Customer_Revenue), 2) AS Avg_Customer_Revenue
FROM (
	SELECT
		CustomerID,
        InvoiceNo,
        Revenue,
        SUM(Revenue) AS Customer_Revenue
	FROM retail_clean
    GROUP BY CustomerID
) AS customer_summary;

SELECT
	(SELECT COUNT(DISTINCT CustomerID)
    FROM retail_clean) AS Total_Customers,
    (SELECT COUNT(DISTINCT InvoiceNo)
    FROM retail_clean) AS Total_Transactions,
    (SELECT ROUND(SUM(Revenue), 2)
    FROM retail_clean) AS Total_Revenue,
    (SELECT ROUND(AVG(Customer_Revenue), 2)
    FROM (
		SELECT
			CustomerID,
            SUM(Revenue) AS Customer_Revenue
		FROM retail_clean
        GROUP BY CustomerID
	) AS customer_summary
    ) AS Avg_Customer_Revenue;

