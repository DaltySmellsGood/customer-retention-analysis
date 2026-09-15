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