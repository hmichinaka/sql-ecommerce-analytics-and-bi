/*
6. For the gsearch lander test, please estimate the revenue that test earned us (Hint: Look at the increase in CVR
from the test (Jun 19 – Jul 28), and use nonbrand sessions and revenue since then to calculate incremental value)
*/
DROP TEMPORARY TABLE IF EXISTS first_test_pageviews;
DROP TEMPORARY TABLE IF EXISTS nonbrand_test_sessions_w_entry_pages;
DROP TEMPORARY TABLE IF EXISTS nonbrand_test_sessions_w_orders;

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

-- cvr for /home : 0.0318
-- cvr for /lander-1 : 0.0406
-- /lander-1 has 0.0087 more cvr

-- Finding the most recent pageview for gsearch nonbrand where the traffic was sent to /home
SELECT
	MAX(s.website_session_id) AS most_recent_gsearch_nonbrand_home_pageview
FROM website_sessions AS s
	LEFT JOIN website_pageviews AS p
		ON s.website_session_id = p.website_session_id
WHERE utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
    AND pageview_url = '/home'
    AND s.created_at < '2012-11-27'
;
-- max website_session_id = 17145

SELECT
	COUNT(website_session_id) AS sessions_since_test
FROM website_sessions
WHERE created_at < '2012-11-27'
	AND website_session_id > '17145' -- last /home session
	AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
;
-- 22,972 website sessions since the test 
-- x 0.0087 incremental conversion 
-- = 202 incremental ordres since 2012-07-29 (ca. 4 months)