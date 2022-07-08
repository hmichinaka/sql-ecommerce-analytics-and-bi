/*
Query clickthrough rates from '/products' page with the number of sessions.
The product #2 is launched on January 6, 2013, so we take the time window 3 months before/after that.
*/
DROP TEMPORARY TABLE IF EXISTS products_pageviews, w_next_pageview, w_next_url;

-- Step 1: find the relevant '/products' pageviews with website_session_id
CREATE TEMPORARY TABLE products_pageviews
SELECT
	website_session_id,
    website_pageview_id,
	CASE
		WHEN created_at < '2013-01-06' THEN 'A. Post_Product_1' 
        ELSE 'B. Post_Procust_2' 
	END AS time_period
FROM website_pageviews
WHERE created_at BETWEEN '2012-10-06' AND '2013-04-06' -- 3 months before/after the launch of product #2
	AND pageview_url = '/products'
;

-- Step 2: find the next pageview_id that occurs after the product pageview
CREATE TEMPORARY TABLE w_next_pageview
SELECT
	p.time_period,
	p.website_session_id,
    MIN(p.website_pageview_id) AS product_pageview_id,
    MIN(w.website_pageview_id) AS next_pageview_id
FROM products_pageviews AS p
	LEFT JOIN website_pageviews AS w
		ON p.website_session_id = w.website_session_id
		AND p.website_pageview_id < w.website_pageview_id
GROUP BY 1, 2
;

-- Step 3: find the pageview_url associated with any applicable next pageview_id
CREATE TEMPORARY TABLE w_next_url
SELECT 
	n.time_period,
	n.website_session_id,
	pageview_url AS next_url
FROM w_next_pageview AS n
	LEFT JOIN website_pageviews AS p
		ON n.next_pageview_id = p.website_pageview_id
;

-- Step 4: summarize the data and analyze the pre vs post periods
SELECT
	time_period,
	COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN next_url IS NOT NULL THEN website_session_id ELSE NULL END) AS next_page,
    COUNT(DISTINCT CASE WHEN next_url IS NOT NULL THEN website_session_id ELSE NULL END) / COUNT(DISTINCT website_session_id) AS ctr_next_page,
    COUNT(DISTINCT CASE WHEN next_url = '/the-original-mr-fuzzy' THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN next_url = '/the-original-mr-fuzzy' THEN website_session_id ELSE NULL END) / COUNT(DISTINCT website_session_id) AS ctr_mrfuzzy,
    COUNT(DISTINCT CASE WHEN next_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END)AS to_lovebear,
    COUNT(DISTINCT CASE WHEN next_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END) / COUNT(DISTINCT website_session_id) AS ctr_lovebear
FROM w_next_url
GROUP BY 1
;