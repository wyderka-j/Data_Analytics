---Inspecting Data
SELECT * FROM sales_data_sample

--CHecking unique values
SELECT DISTINCT status FROM sales_data_sample
SELECT DISTINCT year_id FROM sales_data_sample
SELECT DISTINCT PRODUCTLINE FROM sales_data_sample
SELECT DISTINCT COUNTRY FROM sales_data_sample
SELECT DISTINCT DEALSIZE FROM sales_data_sample
SELECT DISTINCT TERRITORY FROM sales_data_sample

SELECT DISTINCT MONTH_ID FROM sales_data_sample
WHERE year_id = 2003

---------------------------------ANALYSIS---------------------------------
----grouping sales by productline
SELECT PRODUCTLINE, SUM(sales) Revenue
FROM sales_data_sample
GROUP BY PRODUCTLINE
ORDER BY 2 DESC

----grouping sales by year
SELECT YEAR_ID, SUM(sales) Revenue
FROM sales_data_sample
GROUP BY YEAR_ID
ORDER BY 2 DESC

----grouping sales by dealsize
SELECT  DEALSIZE,  SUM(sales) Revenue
FROM sales_data_sample
GROUP BY  DEALSIZE
ORDER BY 2 DESC


----What was the best month for sales in a specific year? How much was earned that month? 
SELECT  MONTH_ID, SUM(sales) Revenue, COUNT (ORDERNUMBER) Frequency
FROM sales_data_sample
WHERE YEAR_ID = 2003 --change year to see the rest
GROUP BY  MONTH_ID
ORDER BY 2 DESC


--November seems to be the month, what product do they sell in November
SELECT  MONTH_ID, PRODUCTLINE, SUM(sales) Revenue, COUNT(ORDERNUMBER)
FROM sales_data_sample
WHERE YEAR_ID = 2003 AND MONTH_ID = 11 --change year to see the rest
GROUP BY  MONTH_ID, PRODUCTLINE
ORDER BY 3 DESC


----Who is our best customer (this could be best answered with RFM, (Recency- last order date, Frequency - count of total orders, Monetary value - total spend))

DROP TABLE IF EXISTS #rfm
;WITH rfm AS
(
	SELECT 
		CUSTOMERNAME, 
		SUM(sales) MonetaryValue,
		AVG(sales) AvgMonetaryValue,
		COUNT(ORDERNUMBER) Frequency,
		MAX(ORDERDATE) last_order_date,
		(SELECT MAX(ORDERDATE) FROM sales_data_sample) max_order_date,
		DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from sales_data_sample)) Recency
	FROM sales_data_sample
	GROUP BY CUSTOMERNAME
),
rfm_calc AS
(
	SELECT r.*,
		NTILE(4) OVER (ORDER BY Recency DESC) rfm_recency,
		NTILE(4) OVER (ORDER BY Frequency) rfm_frequency,
		NTILE(4) OVER (ORDER BY MonetaryValue) rfm_monetary
	FROM rfm r	
)
SELECT
	c.*, rfm_recency+ rfm_frequency+ rfm_monetary AS rfm_cell,
	CAST(rfm_recency As varchar) + CAST(rfm_frequency AS varchar) + CAST(rfm_monetary  AS varchar)rfm_cell_string
INTO #rfm
FROM rfm_calc c




SELECT CUSTOMERNAME , rfm_recency, rfm_frequency, rfm_monetary,
	CASE 
		WHEN rfm_cell_string IN (111, 112 , 121, 122, 123, 132, 211, 212, 114, 141, 221) THEN 'lost_customers'  --lost customers
		WHEN rfm_cell_string IN (133, 134, 143, 244, 334, 343, 344, 144, 232) THEN 'slipping away, cannot lose' -- (Big spenders who haven’t purchased lately) slipping away
		WHEN rfm_cell_string IN (311, 411, 412, 331, 421) THEN 'new customers'
		WHEN rfm_cell_string IN (222, 223, 233, 234, 322) THEN 'potential churners'
		WHEN rfm_cell_string IN (323, 333,321, 422, 332, 432, 423) THEN 'active' --(Customers who buy often & recently, but at low price points)
		WHEN rfm_cell_string IN (433, 434, 443, 444) THEN 'loyal'
	END rfm_segment

FROM #rfm



--What products are most often sold together? 
--select * from sales_data_sample where ORDERNUMBER =  10411

SELECT DISTINCT OrderNumber, STUFF(

	(SELECT ',' + PRODUCTCODE
	FROM sales_data_sample p
	WHERE ORDERNUMBER IN 
		(
			SELECT ORDERNUMBER
			FROM (
				SELECT ORDERNUMBER, COUNT(*) rn
				FROM sales_data_sample
				WHERE STATUS = 'Shipped'
				GROUP BY ORDERNUMBER
			)m
			WHERE rn = 3
		)
		AND p.ORDERNUMBER = s.ORDERNUMBER
		for xml path (''))

		, 1, 1, '') ProductCodes

FROM sales_data_sample s
ORDER BY 2 DESC



--What city has the highest number of sales in a specific country
SELECT city, SUM (sales) Revenue
FROM sales_data_sample
WHERE country = 'UK'
GROUP BY city
ORDER BY 2 DESC


---What is the best product in United States?
SELECT country, YEAR_ID, PRODUCTLINE, SUM(sales) Revenue
FROM sales_data_sample
WHERE country = 'USA'
GROUP BY  country, YEAR_ID, PRODUCTLINE
ORDER BY 4 DESC
