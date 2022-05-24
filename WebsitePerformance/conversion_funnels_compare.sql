/*
Comparing conversion funnel rates of different billing pages (/billing-2 against /billing)
*/
DROP TEMPORARY TABLE IF EXISTS billing_sessions_w_orders;

-- Step 0:finding the first instance of /billing-2 to set analysis timeframe
SELECT 
	MIN(created_at) AS first_created_at,
	MIN(website_pageview_id) AS first_pageview_id
FROM website_pageviews
WHERE pageview_url = '/billing-2' 
	AND created_at IS NOT NULL
;
-- >> first_created_at = '2012-09-10 00:13:05'
-- >> first_pageview_is = 53550

-- Finding the sessions which went to billing page with order_id
CREATE TEMPORARY TABLE billing_sessions_w_orders
SELECT
    p.website_session_id,
	p.pageview_url AS billing_version_seen,
    o.order_id
FROM website_pageviews AS p
	LEFT JOIN orders AS o
		ON p.website_session_id = o.website_session_id
WHERE p.created_at > '2012-09-10'
	AND p.created_at < '2012-11-10'
	AND p.website_pageview_id > 53550
    AND p.pageview_url IN ('/billing', '/billing-2')
;

-- Summarizing by counting total sessions and billing-to-order-ratio for /billing and /billing-2
SELECT
	billing_version_seen,
	COUNT(DISTINCT website_session_id) AS sessions,
	COUNT(DISTINCT order_id) AS orders,
	COUNT(DISTINCT order_id) / COUNT(DISTINCT website_session_id) AS billing_to_order_rt
FROM billing_sessions_w_orders
GROUP BY billing_version_seen
;