---------------------------------------------------------------------------------------------
-- 1. Who is the senior most employee based on job title? 
SELECT * FROM employee

SELECT TOP 1 title, last_name, first_name 
FROM employee
ORDER BY levels DESC

---------------------------------------------------------------------------------------------
-- 2. Which countries have the most Invoices? 
SELECT * FROM invoice

SELECT COUNT(*) AS Counts, billing_country 
FROM invoice
GROUP BY billing_country
ORDER BY Counts DESC

---------------------------------------------------------------------------------------------
-- 3. What are top 3 values of total invoice? 

SELECT TOP 3 total 
FROM invoice
ORDER BY total DESC

---------------------------------------------------------------------------------------------
-- 4. Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
--Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals 

SELECT TOP 1 billing_city,SUM(total) AS InvoiceTotal
FROM invoice
GROUP BY billing_city
ORDER BY InvoiceTotal DESC

---------------------------------------------------------------------------------------------
--5. Who is the best customer? The customer who has spent the most money will be declared the best customer. 
--   Write a query that returns the person who has spent the most money.

SELECT TOP 1 customer.customer_id, first_name, last_name, SUM(total) AS total_spending
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id, first_name, last_name
ORDER BY total_spending DESC

---------------------------------------------------------------------------------------------
-- 6. Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
--    Return your list ordered alphabetically by email starting with A. 

SELECT DISTINCT email,first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
	SELECT track_id FROM track
	JOIN genre ON track.genre_id = genre.genre_id
	WHERE genre.name LIKE 'Rock'
)
ORDER BY email;

---------------------------------------------------------------------------------------------
-- 7. Let's invite the artists who have written the most rock music in our dataset. 
--    Write a query that returns the Artist name and total track count of the top 10 rock bands. 

SELECT TOP 10 artist.artist_id, artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id, artist.name
ORDER BY number_of_songs DESC

---------------------------------------------------------------------------------------------
-- 8. Return all the track names that have a song length longer than the average song length. 
--    Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. 

SELECT name, milliseconds
FROM track
WHERE milliseconds > (
	SELECT AVG(milliseconds) AS avg_track_length
	FROM track )
ORDER BY milliseconds DESC


---------------------------------------------------------------------------------------------
-- 9. Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent 

WITH best_selling_artist AS (
	SELECT TOP 1 artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY artist.artist_id, artist.name
	ORDER BY 3 DESC	
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY c.customer_id, c.first_name, c.last_name, bsa.artist_name
ORDER BY 5 DESC;
