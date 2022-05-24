/*
1. Gsearch seems to be the biggest driver of our business. Could you pull monthly trends 
for gsearch sessions and orders so that we can showcase the growth there?
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
	AND s.utm_source = 'gsearch'
GROUP BY 
    YEAR(s.created_at), 
    MONTH(s.created_at)
;