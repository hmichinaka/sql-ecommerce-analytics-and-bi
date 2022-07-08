/*
Next, let’s showcase all of our efficiency improvements. I would love to show quarterly figures 
since we launched, for session-to-order conversion rate, revenue per order, and revenue per session.
*/
SELECT
	YEAR(s.created_at) AS year,
    QUARTER(s.created_at) AS quarter,
    ROUND(COUNT(DISTINCT order_id) / COUNT(DISTINCT s.website_session_id), 3) AS cvr_session_to_order,
    ROUND(AVG(price_usd), 2) AS revenue_per_order,
    ROUND(SUM(price_usd) / COUNT(DISTINCT s.website_session_id), 2) AS revenue_per_session
FROM website_sessions AS s
	LEFT JOIN orders AS o
		ON s.website_session_id = o.website_session_id
GROUP BY 1, 2
;