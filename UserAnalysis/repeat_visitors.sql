/*
Query the number of website visitors by the number of repeat sessions.
Time period: 1st January, 2014 to 1st November, 2014.
*/
SELECT
	repeat_sessions,
    COUNT(DISTINCT user_id) AS users
FROM(
SELECT
	user_id,
    SUM(is_repeat_session) AS repeat_sessions
FROM website_sessions
WHERE created_at BETWEEN '2014-01-01' AND '2014-11-01'
GROUP BY user_id
HAVING MIN(is_repeat_session) = 0 -- exclude all visitors who visited before January 1st, 2014.
) session_per_user
GROUP BY repeat_sessions
;