/*
Query top entry pages where users are hitting the site. 
*/
-- Find the first pageview for each session
CREATE TEMPORARY TABLE first_pageview
SELECT 
	website_session_id AS entry_id,
	MIN(website_pageview_id) AS first_pv
FROM website_pageviews
WHERE created_at < '2012-06-12'
GROUP BY website_session_id;

-- Find the url the customer saw on that first pageview
SELECT 
	p.pageview_url,
	COUNT(DISTINCT f.entry_id) AS sessions
FROM first_pageview AS f
 	LEFT JOIN website_pageviews AS p
 		ON f.first_pv = p.website_pageview_id
GROUP BY p.pageview_url
;
