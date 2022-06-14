/*
Query conversion funnels from each of two product pages to conversion,
including all website traffic.
*/
DROP TEMPORARY TABLE IF EXISTS product_seen, page_flagging, page_sessions;

-- Step 1: select all pageviews for relevant sessions
CREATE TEMPORARY TABLE product_seen
SELECT
	CASE 
		WHEN pageview_url = '/the-forever-love-bear' THEN 'lovebear'
		WHEN pageview_url = '/the-original-mr-fuzzy' THEN 'mrfuzzy'
        ELSE NULL 
    END AS product_seen,
    website_pageview_id,
    website_session_id
FROM website_pageviews
WHERE pageview_url IN ('/the-forever-love-bear', '/the-original-mr-fuzzy')
	AND created_at BETWEEN '2013-01-06' AND '2014-04-10' -- The product #2 is released on Jan. 6, 2013.
;

-- Step 2: make the summary with flags per session after cutting off the pageviews only after the product is seen
CREATE TEMPORARY TABLE page_flagging
SELECT
	product_seen,
	p.website_session_id,
    MAX(CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END) AS cart_page,
    MAX(CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END) AS shipping_page,
    MAX(CASE WHEN pageview_url IN ('/billing', '/billing-2') THEN 1 ELSE 0 END) AS billing_page,
    MAX(CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END) AS thankyou_page
FROM product_seen AS p
	LEFT JOIN website_pageviews AS w
		ON p.website_session_id = w.website_session_id
		AND p.website_pageview_id < w.website_pageview_id
GROUP BY 1, 2
;

-- Step 3: count the number of sessions for each 
CREATE TEMPORARY TABLE page_sessions
SELECT
	product_seen,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN cart_page = 1 THEN website_session_id ELSE NULL END) AS to_cart,
    COUNT(DISTINCT CASE WHEN shipping_page = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
    COUNT(DISTINCT CASE WHEN billing_page = 1 THEN website_session_id ELSE NULL END) AS to_billing,
    COUNT(DISTINCT CASE WHEN thankyou_page = 1 THEN website_session_id ELSE NULL END) AS to_thankyou
FROM page_flagging
GROUP BY 1
;

-- Output 1: Sessions for each page
SELECT *
FROM page_sessions;

-- Output 2: Click-through rate
SELECT
	product_seen,
    to_cart / sessions AS product_page_click_rt,
    to_shipping / to_cart AS cart_click_rt,
    to_billing / to_shipping AS shipping_click_rt,
    to_thankyou / to_billing AS billing_click_rt
FROM page_sessions;

