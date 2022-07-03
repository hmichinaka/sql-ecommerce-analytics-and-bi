/*
On Decemver 12trh 2013, a third product is launched.
Run a pre-post analysis comparing the month before vs. the month after, in terms of
session-to-order conversion rate, AOV, products per order, and revenue per session?
*/
SELECT
	CASE 
		WHEN s.created_at < '2013-12-12' THEN 'A. Pre_Birthday_Bear'
        ELSE 'B. Post_Birthday_Bear'
	END AS time_period,
    COUNT(DISTINCT order_id) / COUNT(DISTINCT s.website_session_id) AS conv_rate,
    ROUND(AVG(price_usd),3) AS aov,
    ROUND(SUM(items_purchased) / COUNT(DISTINCT order_id),3) AS products_per_order,
    ROUND(SUM(price_usd) / COUNT(DISTINCT s.website_session_id),3) AS revenue_per_session
FROM website_sessions AS s
	LEFT JOIN orders AS o
		ON o.website_session_id = s.website_session_id
WHERE s.created_at BETWEEN '2013-11-12' AND '2014-01-12'
GROUP BY 1
;