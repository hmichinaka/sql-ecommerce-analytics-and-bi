/*
Query the weekly numbers of the sessions entrying /lander-1 or /home with the overall bounce rate
*/

-- Step 1: finding the first website_pageview_id for relevant sessions
-- Step 2: counting pageviews for each session, to identify "bounce"
CREATE TEMPORARY TABLE sessions_w_pv_count
SELECT
    s.website_session_id,
    MIN(p.website_pageview_id) AS entry_pv_id,
    COUNT(p.website_pageview_id) AS count_pageviews
FROM website_sessions AS s
	LEFT JOIN website_pageviews AS p
		ON s.website_session_id = p.website_session_id
WHERE s.created_at > '2012-06-01'    
	AND s.created_at < '2012-08-31'
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
GROUP BY s.website_session_id
;

-- Step 3: identifying the landing page of each session and session starting time
CREATE TEMPORARY TABLE sessions_w_counts_and_time
SELECT
    c.website_session_id,
    c.entry_pv_id,
    c.count_pageviews,
    p.pageview_url AS entry_page,
    p.created_at AS session_created_at
FROM sessions_w_pv_count AS c
	LEFT JOIN website_pageviews AS p
		ON c.entry_pv_id = p.website_pageview_id
;

-- Step 4: summarizing by week(bounve rate, sessions to each lander)
SELECT
    MIN(DATE(session_created_at)) AS week_start_date,
	COUNT(DISTINCT CASE WHEN count_pageviews = 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT website_session_id) AS bounce_rate,
	COUNT(DISTINCT CASE WHEN entry_page = '/home' THEN website_session_id ELSE NULL END) AS home_sessions,
	COUNT(DISTINCT CASE WHEN entry_page = '/lander-1' THEN website_session_id ELSE NULL END) AS lander_sessions
FROM sessions_w_counts_and_time
GROUP BY
    YEAR(session_created_at),
	WEEK(session_created_at)
;