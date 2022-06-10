/*
Query the average website session volume, by hour of day and by day week
to estimate how many live chat support representatives are required.
The holiday period between Sep 15 - Nov 15, 2012 is removed from this analysis.
*/
WITH daily_hourly_sessions AS (
SELECT
	DATE(created_at) AS date,
	HOUR(created_at) AS hr,
    WEEKDAY(created_at) AS wk,
    COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE created_at BETWEEN '2012-09-15' AND '2012-11-15'
GROUP BY 1, 2, 3
)
SELECT
	hr,
    ROUND(AVG(CASE WHEN wk = 0 THEN sessions ELSE NULL END),2) AS mon,
    ROUND(AVG(CASE WHEN wk = 1 THEN sessions ELSE NULL END),2) AS tue,
    ROUND(AVG(CASE WHEN wk = 2 THEN sessions ELSE NULL END),2) AS wed,
    ROUND(AVG(CASE WHEN wk = 3 THEN sessions ELSE NULL END),2) AS thr,
    ROUND(AVG(CASE WHEN wk = 4 THEN sessions ELSE NULL END),2) AS fri,
    ROUND(AVG(CASE WHEN wk = 5 THEN sessions ELSE NULL END),2) AS sat,
    ROUND(AVG(CASE WHEN wk = 6 THEN sessions ELSE NULL END),2) AS sun,
	ROUND(AVG(sessions), 2) AS total_avg
FROM daily_hourly_sessions
GROUP BY hr
;