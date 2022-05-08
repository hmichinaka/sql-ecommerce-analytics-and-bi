/*
Query the list of utm_content and the numbers of sessions and orders for each.
Then, calculate the session to order conversion rate to measure the effecticity of each campaign.
*/
SELECT
	website_sessions.utm_content,
	COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
	COUNT(DISTINCT orders.order_id) /COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_conv_rt 
FROM website_sessions
	LEFT JOIN orders 
		ON orders.website_session_id = website_sessions.website_session_id
GROUP BY website_sessions.utm_content
ORDER BY sessions DESC;



