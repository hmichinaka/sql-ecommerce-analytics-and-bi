/*
First, I’d like to show our volume growth. Can you pull overall session and order volume, 
trended by quarter for the life of the business? Since the most recent quarter is incomplete, 
you can decide how to handle it.
*/
SELECT
	YEAR(s.created_at) AS year,
	QUARTER(s.created_at) AS quarter,
    COUNT(DISTINCT s.website_session_id) AS sessions,
    COUNT(DISTINCT order_id) AS orders
FROM website_sessions AS s
	LEFT JOIN orders AS o
		ON s.website_session_id = o.website_session_id
GROUP BY 1, 2
ORDER BY 1, 2
;