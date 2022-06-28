/*
On September 25th we started givig customers the option to add 2nd product while on the /cart page.
We want to compare the month before vs the month after the change. Calculate the followings:
CTR from the /cart page, Avg Products per Order, AOV (Average Order Volume), and overall revenue per /cart page view.
*/

-- Step 1: Creat time period category and flag of /cart and /shipping for each session
WITH cart_and_shipping AS (
SELECT
	website_session_id,
	CASE 
		WHEN MIN(created_at) BETWEEN '2013-08-25' AND '2013-09-25' THEN 'A. Pre_Cross_Sell'
		WHEN MIN(created_at) BETWEEN '2013-09-26' AND '2013-10-26' THEN 'B. Post_Cross_Sell'
        ELSE NULL
	END AS time_period,
	MAX(CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END) AS is_cart,
	MAX(CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END) is_shipping
FROM website_pageviews 
GROUP BY 1
HAVING time_period IS NOT NULL
),
-- Step 2: JOIN with orders table for revenue
cart_and_order AS(
SELECT
	c.website_session_id,
    order_id,
    time_period,
    is_cart,
    is_shipping,
    items_purchased,
    price_usd
FROM cart_and_shipping AS c
	LEFT JOIN orders AS o
		ON c.website_session_id = o.website_session_id
)
--  Step 3: Group by the time period and calculate the requested values
SELECT
	time_period,
    COUNT(DISTINCT CASE WHEN is_cart = 1 THEN website_session_id ELSE NULL END) AS cart_sessions,
    COUNT(DISTINCT CASE WHEN is_shipping = 1 THEN website_session_id ELSE NULL END) AS clickthroughs,
    ROUND(COUNT(DISTINCT CASE WHEN is_shipping = 1 THEN website_session_id ELSE NULL END) /
		COUNT(DISTINCT CASE WHEN is_cart = 1 THEN website_session_id ELSE NULL END), 3) AS cart_crt,
	ROUND(SUM(items_purchased) / COUNT(DISTINCT order_id), 3) AS products_per_order,
	ROUND(AVG(price_usd), 3) AS AOV,
	ROUND(SUM(price_usd) / COUNT(DISTINCT CASE WHEN is_cart = 1 THEN website_session_id ELSE NULL END), 3 )  AS total_revenue
FROM cart_and_order
GROUP BY 1
;