/*
Comparing bounce rates of different entry pages (/lander-1 against /home 'nonbrand gsearch')
*/

-- Step 0:finding the first instance of /lander-1 to set analysis timeframe
SELECT 
	MIN(created_at) AS first_created_at,
	MIN(website_pageview_id) AS first_pageview_id
FROM website_pageviews
WHERE pageview_url = '/lander-1' 
	AND created_at IS NOT NULL
;
-- >> first_created_at = '2012-06-19 00:35:54'
-- >> first_pageview_is = 23504

-- Step 1: finding the first website_pageview_id for relevant sessions
CREATE TEMPORARY TABLE entry_test_pageviews
SELECT
	p.website_session_id,
    MIN(p.website_pageview_id) AS entry_pv_id
FROM website_pageviews AS p
	INNER JOIN website_sessions AS s
		ON p.website_session_id = s.website_session_id
        AND s.created_at < '2012-07-28'
        AND p.website_pageview_id > 23504
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY p.website_session_id;

-- Step 2: identifying the landing page of each session
CREATE TEMPORARY TABLE test_sessions_w_entry_page
SELECT 
	t.website_session_id,
	p.pageview_url AS entry_page
FROM entry_test_pageviews AS t
	LEFT JOIN website_pageviews AS p
		ON t.entry_pv_id = p.website_pageview_id
WHERE p.pageview_url IN ('/home', '/lander-1')
;

-- Step 3: counting pageviews for each session, to identify "bounce"
CREATE TEMPORARY TABLE test_bounced_sessions
SELECT
	ts.website_session_id,
    ts.entry_page,
    COUNT(DISTINCT p.website_pageview_id) AS count_of_pv
FROM test_sessions_w_entry_page AS ts
	LEFT JOIN website_pageviews AS p
		ON ts.website_session_id = p.website_session_id
GROUP BY 
	ts.website_session_id,
    ts.entry_page
HAVING
	COUNT(p.website_pageview_id) = 1
;

-- Step 4: summarizing by counting total sessions and bounced sessions
SELECT
	ts.entry_page,
	COUNT(DISTINCT ts.website_session_id) AS sessions,
	COUNT(DISTINCT tb.website_session_id) AS bounced_sessions,
	COUNT(DISTINCT tb.website_session_id) / COUNT(DISTINCT ts.website_session_id) AS bounce_rate
FROM test_sessions_w_entry_page AS ts
	LEFT JOIN test_bounced_sessions AS tb
		ON ts.website_session_id = tb.website_session_id
GROUP BY ts.entry_page
;

