/*
Query a breakdown of the total number of sessions by UTM source, 
campaign and referring domain. The request was made on 12.04.2012.
*/
SELECT 
	utm_source,
	utm_campaign,
	http_referer,
	COUNT(DISTINCT website_session_id) as number_of_sessions
FROM website_sessions
WHERE created_at < '2012-04-12'
GROUP BY 
	utm_source, 
	utm_campaign, 
	http_referer
ORDER BY number_of_sessions DESC;


