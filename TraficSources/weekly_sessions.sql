/*
Query the weekly numbers of the sessions for the campaign 'gsearch nonbrand',
since the campaign was bid down on 2012-04-15. The request was made on 2012-05-10.
*/
SELECT 
	MIN(DATE(created_at)) AS week_start_date,
	COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE created_at < '2012-05-10'
	AND utm_source = 'gsearch' 
	AND utm_campaign = 'nonbrand'
GROUP BY 
	YEAR(created_at), 
	WEEK(created_at)
;