/*
Query monthly and weekly session and order volumes in 2012.
*/
-- Monthly volume
SELECT
	YEAR(s.created_at) AS yr,
	MONTH(s.created_at) AS mo,
	COUNT(DISTINCT s.website_session_id) AS sessions,
	COUNT(DISTINCT o.order_id) AS orders
FROM website_sessions AS s
	LEFT JOIN orders AS o
		ON s.website_session_id = o.website_session_id
WHERE s.created_at < '2013-01-01'
GROUP BY 
	YEAR(s.created_at), 
    MONTH(s.created_at)
;

-- Weekly volume
SELECT
	MIN(DATE(s.created_at)) AS week_start_date,
    WEEK(s.created_at) AS wk,
	COUNT(DISTINCT s.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders
FROM website_sessions AS s
	LEFT JOIN orders AS o
		ON s.website_session_id = o.website_session_id
WHERE s.created_at < '2013-01-01'
GROUP BY WEEK(s.created_at) 
;
