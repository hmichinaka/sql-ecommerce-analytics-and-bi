/*
Query the comparison of conversion rates and revenue per session
for repeat sessions vs new sessions.
*/
SELECT
	is_repeat_session,
    COUNT(DISTINCT s.website_session_id) AS sessions,
    COUNT(DISTINCT order_id) / COUNT(DISTINCT s.website_session_id) AS conv_rate,
    ROUND(SUM(price_usd) / COUNT(DISTINCT s.website_session_id), 3) AS rev_per_session
FROM website_sessions AS s
	LEFT JOIN orders AS o
		ON s.website_session_id = o.website_session_id
WHERE s.created_at BETWEEN '2014-01-01' AND '2014-11-08'
GROUP BY 1
;