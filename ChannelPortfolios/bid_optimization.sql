/*
Query the numbers of sessions, orders and conversion rate for each device_type and utm_source.
Data period: from 2012-08-22 to 2012-09-18
*/
SELECT
	device_type,
	utm_source,
	COUNT(DISTINCT s.website_session_id) AS sessions,
	COUNT(DISTINCT order_id) AS orders,
 	COUNT(DISTINCT order_id) / COUNT(DISTINCT s.website_session_id) AS conv_rate
FROM website_sessions AS s
	LEFT JOIN orders AS o
		ON s.website_session_id = o.website_session_id
WHERE s.created_at BETWEEN '2012-08-22' AND '2012-09-19'
	AND utm_source IN ('gsearch', 'bsearch')
	AND utm_campaign = 'nonbrand'
GROUP BY 
	device_type,
	utm_source
;