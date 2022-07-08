/*
Next, let’s show the overall session-to-order conversion rate trends for those same channels, by quarter. 
Please also make a note of any periods where we made major improvements or optimizations.
*/
SELECT
	YEAR(s.created_at) AS year,
    QUARTER(s.created_at) AS quarter,
	COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN order_id ELSE NULL END) /
		COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN s.website_session_id ELSE NULL END) AS cvr_Gsearch_nonbrand,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN order_id ELSE NULL END) /
		COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN s.website_session_id ELSE NULL END) AS cvr_Bsearch_nonbrand,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN order_id ELSE NULL END) /
		COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN s.website_session_id ELSE NULL END) AS cvr_Brand_overall,
    COUNT(DISTINCT CASE WHEN http_referer IN ('https://www.gsearch.com', 'https://bsearch.com') THEN order_id ELSE NULL END) /
		COUNT(DISTINCT CASE WHEN http_referer IN ('https://www.gsearch.com', 'https://bsearch.com') THEN s.website_session_id ELSE NULL END) AS cvr_Organic_search,
	COUNT(DISTINCT CASE WHEN http_referer IS NULL THEN order_id ELSE NULL END) /
		COUNT(DISTINCT CASE WHEN http_referer IS NULL THEN s.website_session_id ELSE NULL END) AS cvr_Direct_type_in
FROM website_sessions AS s
	LEFT JOIN orders AS o
		ON s.website_session_id = o.website_session_id
GROUP BY 1, 2
;
-- I found a jump of cvr in Q1-2013 then gradually increasing till today
