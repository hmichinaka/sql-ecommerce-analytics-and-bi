/*
4. I’m worried that one of our more pessimistic board members may be concerned about 
the large % of traffic from Gsearch. Can you pull monthly trends for Gsearch, alongside 
monthly trends for each of our other channels?
*/
-- Unique channels
SELECT DISTINCT
    utm_source,
    utm_campaign,
    http_referer
FROM website_sessions
WHERE created_at < '2012-11-27';

-- Query trends
SELECT
    YEAR(s.created_at) AS year,
	MONTH(s.created_at) AS month,
	COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' THEN s.website_session_id ELSE NULL END) AS gsearch_paid_sessions,
	COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN s.website_session_id ELSE NULL END) AS bsearch_paid_sessions,
	COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN s.website_session_id ELSE NULL END) AS organic_search_sessions,
	COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN s.website_session_id ELSE NULL END) AS direct_type_in_sessions
FROM website_sessions AS s
    LEFT JOIN orders AS o
		ON s.website_session_id = o.website_session_id
WHERE s.created_at < '2012-11-27'
GROUP BY 
    YEAR(created_at),
    MONTH(created_at)
;