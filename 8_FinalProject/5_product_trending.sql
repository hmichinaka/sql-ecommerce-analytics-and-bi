/*
We’ve come a long way since the days of selling a single product. Let’s pull monthly trending 
for revenue and margin by product, along with total sales and revenue. Note anything you notice about seasonality.
*/
SELECT
	YEAR(created_at) AS year,
    MONTH(created_at) AS month,
    ROUND(SUM(CASE WHEN product_id = 1 THEN price_usd ELSE NULL END), 0) AS 1_revenue,
    ROUND(SUM(CASE WHEN product_id = 1 THEN price_usd - cogs_usd ELSE NULL END), 0) AS 1_margin,
	ROUND(SUM(CASE WHEN product_id = 2 THEN price_usd ELSE NULL END), 0) AS 2_revenue,
    ROUND(SUM(CASE WHEN product_id = 2 THEN price_usd - cogs_usd ELSE NULL END), 0) AS 2_margin,
	ROUND(SUM(CASE WHEN product_id = 3 THEN price_usd ELSE NULL END), 0) AS 3_revenue,
    ROUND(SUM(CASE WHEN product_id = 3 THEN price_usd - cogs_usd ELSE NULL END), 0) AS 3_margin,
	ROUND(SUM(CASE WHEN product_id = 4 THEN price_usd ELSE NULL END), 0) AS 4_revenue,
    ROUND(SUM(CASE WHEN product_id = 4 THEN price_usd - cogs_usd ELSE NULL END), 0) AS 4_margin
FROM order_items
GROUP BY 1,2
;



SELECT *
FROM orders
;