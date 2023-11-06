-- Create using MySQL

CREATE DATABASE Customer_Shopping_Trends;
USE Customer_Shopping_Trends;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Number of women and men and their percentage
WITH total AS (
SELECT
	Gender,
	COUNT(`Customer ID`) AS client_count

FROM shopping_trends_updated
GROUP BY 1
ORDER BY 2 DESC
)
SELECT
	SUM(CASE WHEN Gender = 'Male' THEN client_count ELSE 0 END) count_male,
	SUM(CASE WHEN Gender = 'Female' THEN client_count ELSE 0 END) count_Female,
	ROUND(SUM(CASE WHEN Gender = 'Male' THEN client_count ELSE 0 END)/
     (SUM(CASE WHEN Gender = 'Male' THEN client_count ELSE 0 END)
     + SUM(CASE WHEN Gender = 'Female' THEN client_count ELSE 0 END)) *100,2) pct_male,

	ROUND(SUM(CASE WHEN Gender = 'Female' THEN client_count ELSE 0 END)/
     (SUM(CASE WHEN Gender = 'Male' THEN client_count ELSE 0 END)
     + SUM(CASE WHEN Gender = 'Female' THEN client_count ELSE 0 END)) *100,2) pct_female
from total;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
# -- What Age Group do we mostly serve
SELECT MAX(Age) AS max_age, MIN(Age) AS min_age
FROM shopping_trends_updated;
-- MAX 70, MIN 18

SELECT
	CASE
     WHEN Age BETWEEN 18 AND 31 THEN '18-31'
     WHEN Age BETWEEN 32 AND 45 THEN '32-45'
     WHEN Age BETWEEN 46 AND 59 THEN '46-59'
     WHEN Age BETWEEN 60 AND 70 THEN '60-70'
	END AS age_groups,
    COUNT(`Customer ID`) AS client_count
FROM shopping_trends_updated
GROUP BY 1
ORDER BY 2 DESC;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 -- What is the most and least popular category
SELECT
	Category,
	COUNT(`Customer ID`) AS client_count
FROM shopping_trends_updated
GROUP BY 1
ORDER BY 2 DESC;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 -- Which season has the most purchases
SELECT
	Season,
	COUNT(`Customer ID`) as purchase_count
FROM shopping_trends_updated
GROUP BY 1
ORDER BY 2 DESC;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Most popular payment method
SELECT
	`Payment Method`,
    COUNT(`Customer ID`) AS purchase_count
FROM shopping_trends_updated
GROUP BY 1
ORDER BY 2 DESC;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Most popular shipping type
SELECT
	`Shipping Type`,
    COUNT(`Customer ID`) AS purchase_count
FROM shopping_trends_updated
GROUP BY 1
ORDER BY 2 DESC;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Most popular item
SELECT
	`Item Purchased`,
	COUNT(`Customer ID`) AS items_purchased
FROM shopping_trends_updated
GROUP BY 1
ORDER BY 2 DESC
LIMIT 20;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 -- Find the most purchased item by age groups
SELECT
	CASE
     WHEN Age BETWEEN 18 AND 31 THEN '18-31'
     WHEN Age BETWEEN 32 AND 45 THEN '32-45'
     WHEN Age BETWEEN 46 AND 59 THEN '46-59'
     WHEN Age BETWEEN 60 AND 70 THEN '60-70'
	END AS age_groups,
    `Item Purchased`,
    COUNT(`Customer ID`) AS client_count
FROM shopping_trends_updated
GROUP BY 1,2
ORDER BY 3 DESC;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Find the most common payment method used by age groups
SELECT
	CASE
     WHEN Age BETWEEN 18 AND 31 THEN '18-31'
     WHEN Age BETWEEN 32 AND 45 THEN '32-45'
     WHEN Age BETWEEN 46 AND 59 THEN '46-59'
     WHEN Age BETWEEN 60 AND 70 THEN '60-70'
	END AS age_groups,
	`Payment Method`,
	COUNT(`Customer ID`) AS no_clients
FROM shopping_trends_updated
GROUP BY 1,2
ORDER BY 3 DESC;