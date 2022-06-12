/*
Query monthly order volume, overall conversion rates, revenue persession, and
a breakdown of sales by product (product#1 and #2) between April 1, 2012 to April 1, 2013.
Note: Product #2 is released in January 6, 2013.
*/
SELECT 
	YEAR(s.created_at) AS yr,
    MONTH(s.created_at) AS mo,
    COUNT(DISTINCT s.website_session_id) AS sessions,
	COUNT(DISTINCT order_id) AS orders,
    ROUND((COUNT(DISTINCT o.order_id) / COUNT(DISTINCT s.website_session_id)), 4)AS conv_rate,
	ROUND((SUM(o.price_usd) / COUNT(DISTINCT s.website_session_id)), 2) AS revenue_per_session,
	COUNT(DISTINCT CASE WHEN primary_product_id = 1 THEN order_id ELSE NULL END) AS product_one_orders,
	COUNT(DISTINCT CASE WHEN primary_product_id = 2 THEN order_id ELSE NULL END) AS product_two_orders
FROM website_sessions AS s
	LEFT JOIN orders AS o
		ON s.website_session_id = o.website_session_id
WHERE s.created_at BETWEEN '2012-04-01' AND '2013-04-01'
GROUP BY 1, 2
;