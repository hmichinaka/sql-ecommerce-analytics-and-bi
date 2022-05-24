/*
3. While we’re on Gsearch, could you dive into nonbrand, and pull monthly sessions and orders split by device
type? I want to flex our analytical muscles a little and show the board we really know our traffic sources.
*/
SELECT 
	YEAR(s.created_at) AS year,
    MONTH(s.created_at) AS month,
 	COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN s.website_session_id ELSE NULL END) AS desktop_sessions,
	COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN o.order_id ELSE NULL END) AS desktop_orders,
	COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN s.website_session_id ELSE NULL END) AS mobile_sessions,
	COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN o.order_id ELSE NULL END) AS mobile_orders
FROM website_sessions AS s
	LEFT JOIN orders AS o
		ON s.website_session_id = o.website_session_id
WHERE s.created_at < '2012-11-27'
	AND s.utm_source = 'gsearch'
    AND s.utm_campaign = 'nonbrand'
GROUP BY 
    YEAR(s.created_at), 
    MONTH(s.created_at)
;
