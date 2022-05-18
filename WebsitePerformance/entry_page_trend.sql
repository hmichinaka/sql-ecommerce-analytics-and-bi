/*
Query the weekly numbers of the sessions entrying /lander-1 or /home with the overall bounce rate
*/

-- Step 1: finding the first website_pageview_id for relevant sessions

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

SELECT * FROM sessions_w_counts_and_time;

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


-- Step 2: identifying the landing page of each session
CREATE TEMPORARY TABLE sessions_w_entry_page
SELECT 
	e.website_session_id,
	p.pageview_url AS entry_page
FROM entry_pageviews AS e
	LEFT JOIN website_pageviews AS p
		ON e.entry_pv_id = p.website_pageview_id
WHERE p.pageview_url IN ('/home', '/lander-1')
;

-- Step 3: counting pageviews for each session, to identify "bounce"
CREATE TEMPORARY TABLE bounced_sessions
SELECT
	s.website_session_id,
    s.entry_page,
    COUNT(DISTINCT p.website_pageview_id) AS count_of_pv
FROM sessions_w_entry_page AS s
	LEFT JOIN website_pageviews AS p
		ON s.website_session_id = p.website_session_id
GROUP BY 
	s.website_session_id,
    s.entry_page
HAVING
	COUNT(p.website_pageview_id) = 1
;

;


-- Step 4: summarizing by week(bounve rate, sessions to each lander)

SELECT
    MIN(DATE(s.created_at)),
	COUNT(DISTINCT CASE WHEN b.entry_page = '/home' THEN b.website_session_id ELSE NULL END) AS home_sessions,
	COUNT(DISTINCT CASE WHEN b.entry_page = '/lander-1' THEN b.website_session_id ELSE NULL END) AS lander_sessions
FROM bounced_sessions AS b
	LEFT JOIN website_sessions AS s
		ON b.website_session_id = s.website_session_id
GROUP BY
	YEAR(s.created_at),
    MONTH(s.created_at)


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

