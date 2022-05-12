/*
Query the weekly numbers of the sessions for the campaign 'gsearch nonbrand' by device type
in order to check traffic source segment trending.
*/
SELECT 
	MIN(DATE(created_at)) AS week_start_date,
	COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN website_session_id ELSE NULL END) AS dtop_sessions,
	COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mtop_sessions
FROM website_sessions
WHERE created_at BETWEEN '2012-04-15' AND '2012-06-09'
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
GROUP BY
	YEAR(created_at),
    WEEK(created_at)
;