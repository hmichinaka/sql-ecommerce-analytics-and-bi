/*
Query organic search, direct type in and paid brand search sessions by month, and
show those sessions as a % of paid search nonbrand.
*/
SELECT
	YEAR(created_at) AS year,
	MONTH(created_at) AS month,
	COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS 'nonbrand',
	COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN website_session_id ELSE NULL END) AS 'brand',
    ROUND((COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN website_session_id ELSE NULL END) * 100 /
		COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END)), 2) AS 'brand_pct_of_nonbrand',
	COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN website_session_id ELSE NULL END) AS 'direct',
    ROUND((COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN website_session_id ELSE NULL END) * 100 /
    	COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END)), 2) AS 'direct_pct_of_nonbrand',
	COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IN ('https://www.gsearch.com', 'https://www.bsearch.com') THEN website_session_id ELSE NULL END) AS 'organic',
	ROUND((COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IN ('https://www.gsearch.com', 'https://www.bsearch.com') THEN website_session_id ELSE NULL END) * 100 /
		COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END)), 2) AS 'organic_pct_of_nonbrand'
FROM website_sessions
WHERE created_at < '2012-12-23'
GROUP BY
	YEAR(created_at),
    MONTH(created_at)
;