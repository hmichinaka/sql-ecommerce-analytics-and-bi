/*
Let’s dive deeper into the impact of introducing new products. Pull monthly sessions to the /products page, 
and show how the % of those sessions clicking through another page has changed over time, 
along with a view of how conversion from /products to placing an order has improved.
*/
-- Step 1: Finding the relevant website_session_id which visited /products
WITH product_session AS(
SELECT DISTINCT website_session_id
FROM website_pageviews
WHERE pageview_url ='/products'
),
-- Step 2: Note the time at /products page by sessions and flag ordered sessions
product_time AS(
SELECT
	s.website_session_id,
    created_at,
    pageview_url,
	CASE WHEN pageview_url = '/products' THEN created_at ELSE NULL END AS time_at_products,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS is_ordered
FROM product_session AS s
	LEFT JOIN website_pageviews AS p
		ON s.website_session_id = p.website_session_id
),
-- Step 3: Create click-through flag
click_through AS (
SELECT
	website_session_id,
    MIN(created_at) AS session_at,
    CASE WHEN MAX(created_at) > MAX(time_at_products) THEN 1 ELSE 0 END AS is_click_through,
    MAX(is_ordered) AS is_ordered
FROM product_time
GROUP BY 1
)
-- Step 4: Aggregate by month and calcualte CTR and CVR
SELECT
	YEAR(session_at) AS year,
    MONTH(session_at) AS month,
    COUNT(DISTINCT website_session_id) AS products_sessions,
    ROUND(SUM(is_click_through) / COUNT(DISTINCT website_session_id), 3) AS ctr,
	ROUND(SUM(is_ordered) / COUNT(DISTINCT website_session_id), 3) AS cvr_to_order
FROM click_through
GROUP BY 1, 2
ORDER BY 1, 2
;


