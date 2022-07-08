/*
I’d like to show how we’ve grown specific channels. Could you pull a quarterly view of orders 
from Gsearch nonbrand, Bsearch nonbrand, brand search overall, organic search, and direct type-in?
*/
SELECT
	YEAR(created_at) AS year,
    QUARTER(created_at) AS quarter,
	COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS Gsearch_nonbrand,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS Bsearch_nonbrand,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN website_session_id ELSE NULL END) AS Brand_overall,
    COUNT(DISTINCT CASE WHEN http_referer IN ('https://www.gsearch.com', 'https://bsearch.com') THEN website_session_id ELSE NULL END) AS Organic_search,
	COUNT(DISTINCT CASE WHEN http_referer IS NULL THEN website_session_id ELSE NULL END) AS Direct_type_in
FROM website_sessions
GROUP BY 1, 2
;