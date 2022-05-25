/*
6. For the gsearch lander test, please estimate the revenue that test earned us (Hint: Look at the increase in CVR
from the test (Jun 19 – Jul 28), and use nonbrand sessions and revenue since then to calculate incremental value)
*/
DROP TEMPORARY TABLE IF EXISTS first_test_pageviews;

-- Finding the first pageview_id for /lander-1
SELECT MIN(website_pageview_id) AS first_test_pv
FROM website_pageviews
WHERE pageview_url = '/lander-1';
-- website_pageview_id = 23504

-- Finding the first pageview_id for each session
CREATE TEMPORARY TABLE first_test_pageviews
SELECT
	p.website_session_id,
    MIN(p.website_pageview_id) AS min_pageview_id
FROM website_pageviews AS p
	INNER JOIN website_sessions AS s
		ON s.website_session_id = p.website_session_id
        AND s.created_at < '2012-07-28'
		AND p.website_pageview_id >= 23504
		AND s.utm_source = 'gsearch'
		AND s.utm_campaign = 'nonbrand'
GROUP BY
	p.website_session_id
;

-- Adding the entry page to each session
CREATE TEMPORARY TABLE nonbrand_test_sessions_w_entry_pages
SELECT
	f.website_session_id,
    p.pageview_url AS entry_page
FROM first_test_pageviews AS f
	LEFT JOIN website_pageviews AS p
		ON p.website_pageview_id = f.min_pageview_id
WHERE p.pageview_url IN ('/home', '/lander-1')
;

-- Conbine with orders
CREATE TEMPORARY TABLE nonbrand_test_sessions_w_orders
SELECT
	e.website_session_id,
    e.entry_page,
    o.order_id AS order_id
FROM nonbrand_test_sessions_w_entry_pages AS e
	LEFT JOIN orders AS o
		ON e.website_session_id = o.website_session_id
;

-- Calculte the conversion rates for each entry_page
SELECT
	entry_page,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT order_id) / COUNT(DISTINCT website_session_id) AS conv_rate
FROM nonbrand_test_sessions_w_orders
GROUP BY entry_page
;

SELECT
	YEAR(s.created_at) AS year,
    MONTH(s.created_at) AS month,
    SUM(o.price_usd) AS total_order_usd
FROM website_sessions AS s
	LEFT JOIN orders AS o
		ON s.website_session_id = o.website_session_id
GROUP BY
	YEAR(s.created_at),
    MONTH(s.created_at)
;