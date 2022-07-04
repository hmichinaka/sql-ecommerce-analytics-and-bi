/*
*/
-- Step 1: Identify user_id with repeat session and the time for the second session
WITH user_w_second_session AS (
SELECT 
	user_id,
	MIN(created_at) AS second_session_time
FROM website_sessions
WHERE is_repeat_session = 1
GROUP BY user_id
),
-- Step 2: JOIN to the original table and extract the first and the second session by users
first_and_second AS (
SELECT
	u.user_id,
    MIN(created_at) AS first_session_time,
    MAX(second_session_time) AS second_session_time,
    DATEDIFF(MAX(second_session_time), MIN(created_at)) AS date_diff
FROM user_w_second_session AS u
	LEFT JOIN website_sessions AS s
		ON u.user_id = s.user_id
GROUP BY user_id
)
-- Step 3: Calculate the days over all users who made more than two sessions
SELECT
	AVG(date_diff) AS avg_days_first_to_second,
    MIN(date_diff) AS min_days_first_to_second,
    MAX(date_diff) AS max_days_first_to_second 
FROM first_and_second
;