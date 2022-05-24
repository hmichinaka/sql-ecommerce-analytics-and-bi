/*
2. Next, it would be great to see a similar monthly trend for Gsearch, but this time splitting out nonbrand and
brand campaigns separately. I am wondering if brand is picking up at all. If so, this is a good story to tell.
*/
SELECT 
    YEAR(s.created_at) AS year,
	MONTH(s.created_at) AS month,
	COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN s.website_session_id ELSE NULL END) AS nonbrand_sessions,
	COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN o.order_id ELSE NULL END) AS nonbrand_orders,
	COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN s.website_session_id ELSE NULL END) AS brand_sessions,
	COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN o.order_id ELSE NULL END) AS brand_orders
FROM website_sessions AS s
    LEFT JOIN orders AS o
		ON s.website_session_id = o.website_session_id
WHERE s.created_at < '2012-11-27'
	AND s.utm_source = 'gsearch'
GROUP BY 
    YEAR(s.created_at), 
    MONTH(s.created_at)
;