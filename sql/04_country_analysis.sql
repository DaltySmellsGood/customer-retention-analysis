USE online_retail_analysis;

SELECT
	Country,
    COUNT(DISTINCT CustomerID) AS Customers,
    COUNT(DISTINCT InvoiceNo) AS Transactions,
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM retail_clean
GROUP BY Country
ORDER BY Total_Revenue DESC;

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