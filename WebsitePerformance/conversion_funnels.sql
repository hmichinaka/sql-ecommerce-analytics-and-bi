/*
Build the conversion funnel on website for the customer who arrived /lander-1.
*/
DROP TEMPORARY TABLE IF EXISTS sessions_and_pageviews;
DROP TEMPORARY TABLE IF EXISTS session_level_flag;

-- flagging each page by session
CREATE TEMPORARY TABLE session_level_flag
SELECT
	website_session_id,
    MAX(products_page) AS product_made_it,
    MAX(mrfuzzy_page) AS mrfuzzy_made_it,
    MAX(cart_page) AS cart_made_it,
    MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thankyou_page) AS thankyou_made_it
FROM(
-- finding the realted sessions and identifying the funnel step
SELECT
    p.website_pageview_id,
    p.website_session_id,
    p.pageview_url,
	CASE WHEN p.pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
	CASE WHEN p.pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
	CASE WHEN p.pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
	CASE WHEN p.pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
	CASE WHEN p.pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
	CASE WHEN p.pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM website_pageviews AS p
	LEFT JOIN website_sessions AS s
		ON p.website_session_id = s.website_session_id
WHERE p.created_at > '2012-08-05'
	AND p.created_at < '2012-09-05'
    AND s.utm_source = 'gsearch'
    AND s.utm_campaign = 'nonbrand'
) AS pageview_level
GROUP BY website_session_id
;

-- How many pageviews for each page
CREATE TEMPORARY TABLE sessions_and_pageviews
SELECT
	COUNT(DISTINCT website_session_id) AS sessions,
	COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS to_products,
    COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END)  AS to_cart,
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
    COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS to_billing,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) AS to_thankyou
FROM session_level_flag;

-- Query 1: numbers of sessions and pageviews for each page
SELECT * FROM sessions_and_pageviews;

-- Query 2: click-through rate of each page
SELECT
    to_products / sessions AS lander_click_rt,
    to_mrfuzzy / to_products AS products_click_rt,
    to_cart / to_mrfuzzy AS mrfuzzy_click_rt,
    to_shipping / to_cart AS cart_click_rt,
    to_billing / to_shipping AS shipping_click_rt,
    to_thankyou / to_billing AS billing_click_rt
FROM sessions_and_pageviews;
