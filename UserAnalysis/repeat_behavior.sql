/*
Query the minimum, the maximum and the average time between the first and second session for customers who came back.
Time period: 1st January, 2014 to 3rd November, 2014.
*/
-- Step 1: Identify user_id for the relevant new sessions
WITH new_sessions AS( 
SELECT
	user_id,
    created_at AS first_session_time
FROM website_sessions
WHERE 
	created_at BETWEEN '2014-01-01' AND '2014-11-03'
	AND is_repeat_session = 0
),
-- Step 2: Identify the time for the second session and calculate the time differens on 1st/2nd sessions by user_id
second_session AS (
SELECT 
	n.user_id,
    MIN(first_session_time) AS first_session_time, -- MIN is a dummy for aggregation
	MIN(s.created_at) AS second_session_time, -- MIN is neccesary to select the "minimum repeated session" = 2nd session
	DATEDIFF(MIN(s.created_at), MIN(first_session_time)) AS date_diff
FROM new_sessions AS n
	LEFT JOIN website_sessions AS s
		ON n.user_id = s.user_id
WHERE 
	s.created_at BETWEEN '2014-01-01' AND '2014-11-03'
	AND s.is_repeat_session = 1
GROUP BY n.user_id
)
-- Step 3: Calculate the days over all users who made more than two sessions
SELECT
	AVG(date_diff) AS avg_days_first_to_second,
    MIN(date_diff) AS min_days_first_to_second,
    MAX(date_diff) AS max_days_first_to_second 
FROM second_session 
;