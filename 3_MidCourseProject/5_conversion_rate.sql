/*
5. I’d like to tell the story of our website performance improvements over the course of 
the first 8 months. Could you pull session to order conversion rates, by month?
*/
SELECT 
    YEAR(s.created_at) AS year,
    MONTH(s.created_at) AS month,
	COUNT(DISTINCT s.website_session_id) AS sessions,
	COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.order_id) / COUNT(DISTINCT s.website_session_id) AS conv_rate
FROM website_sessions AS s
    LEFT JOIN orders AS o
		ON s.website_session_id = o.website_session_id
WHERE s.created_at < '2012-11-27'
GROUP BY 
    YEAR(s.created_at), 
    MONTH(s.created_at)
;