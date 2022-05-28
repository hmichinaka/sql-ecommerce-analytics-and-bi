/*
8. I’d love for you to quantify the impact of our billing test, as well. 
Please analyze the lift generated from the test (Sep 10 – Nov 10), in terms of 
revenue per billing page session, and then pull the number of billing page sessions 
for the past month to understand monthly impact.
*/

SELECT 
    CASE
		WHEN p.pageview_url = '/billing' THEN '/billing'
        WHEN p.pageview_url = '/billing-2' THEN '/billing-2'
	END AS billing_version,
    COUNT(DISTINCT p.website_session_id) AS sessions,
	SUM(o.price_usd) / COUNT(DISTINCT p.website_session_id) AS usd_per_billing_page_seen
FROM website_pageviews AS p
	LEFT JOIN orders AS o
		ON p.website_session_id = o.website_session_id
WHERE p.created_at > '2012-09-10'
	AND p.created_at < '2012-11-10'
    AND p.pageview_url IN ('/billing', '/billing-2')
GROUP BY 1
;

-- 22.83 USD revenue per billing page seen for the old version
-- 31.34 USD for the new version
-- LIFT: 8.51 USD per billing page view

-- The montly impact from billing page
SELECT
	COUNT(DISTINCT website_session_id) AS sessions
FROM website_pageviews
WHERE created_at BETWEEN '2012-10-27'AND '2012-11-27'
    AND pageview_url IN ('/billing', '/billing-2')
;
-- 1,183 billig session per month x 8.51 USD (lift)
-- Value of billing test: 10,030 USD over the past month