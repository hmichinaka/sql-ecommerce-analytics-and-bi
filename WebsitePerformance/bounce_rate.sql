/*
Calculate bounce rate of the homepage. Request arrived on 14.06.2012.
*/

-- Step 1: finding the first website_pageview_id for relevant sessions
CREATE TEMPORARY TABLE entry_pageviews
SELECT
    website_session_id,
    MIN(website_pageview_id) AS entry_pv_id
FROM website_pageviews
WHERE created_at < '2012-06-14'
GROUP BY website_session_id;

-- Step 2: identifying the landing page of each session
CREATE TEMPORARY TABLE sessions_w_home_entry
SELECT
    e.website_session_id,
    p.pageview_url AS entry_page
FROM entry_pageviews AS e
	LEFT JOIN website_pageviews AS p
		ON e.entry_pv_id = p.website_pageview_id
WHERE p.pageview_url = '/home';

-- Step 3: counting pageviews for each session, to identify "bounce"
CREATE TEMPORARY TABLE bounced_sessions
SELECT
    h.website_session_id,
    h.entry_page,
    COUNT(DISTINCT p.website_pageview_id) AS count_of_pv
FROM sessions_w_home_entry AS h
	LEFT JOIN website_pageviews AS p
		ON h.website_session_id = p.website_session_id
GROUP BY 
    h.website_session_id,
    h.entry_page
HAVING
	COUNT(p.website_pageview_id) = 1
;

-- Step 4: summarizing by counting total sessions and bounced sessions
SELECT
    COUNT(DISTINCT h.website_session_id) AS sessions,
    COUNT(DISTINCT b.website_session_id) AS bounced_sessions,
    COUNT(DISTINCT b.website_session_id) / COUNT(DISTINCT h.website_session_id) AS bounce_rate
FROM sessions_w_home_entry AS h
	LEFT JOIN bounced_sessions AS b
		ON h.website_session_id = b.website_session_id
;

