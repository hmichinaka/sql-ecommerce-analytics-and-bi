/*
There are a couple of quality issues on our products.
Query monthly product refund rate, by product, and confirm the quality issue is fixed by now.
*/
SELECT
	YEAR(i.created_at) AS yr,
    MONTH(i.created_at) AS mo,
	COUNT(DISTINCT CASE WHEN product_id = 1 THEN i.order_item_id ELSE NULL END) AS p1_orders,
	COUNT(DISTINCT CASE WHEN product_id = 1 THEN order_item_refund_id ELSE NULL END) / 
		COUNT(DISTINCT CASE WHEN product_id = 1 THEN i.order_item_id ELSE NULL END) AS p1_refund_rt,
	COUNT(DISTINCT CASE WHEN product_id = 2 THEN i.order_item_id ELSE NULL END) AS p2_orders,
	COUNT(DISTINCT CASE WHEN product_id = 2 THEN order_item_refund_id ELSE NULL END) / 
		COUNT(DISTINCT CASE WHEN product_id = 2 THEN i.order_item_id ELSE NULL END) AS p2_refund_rt,
	COUNT(DISTINCT CASE WHEN product_id = 3 THEN i.order_item_id ELSE NULL END) AS p3_orders,
	COUNT(DISTINCT CASE WHEN product_id = 3 THEN order_item_refund_id ELSE NULL END) / 
		COUNT(DISTINCT CASE WHEN product_id = 3 THEN i.order_item_id ELSE NULL END) AS p3_refund_rt,
	COUNT(DISTINCT CASE WHEN product_id = 4 THEN i.order_item_id ELSE NULL END) AS p4_orders,
	COUNT(DISTINCT CASE WHEN product_id = 4 THEN order_item_refund_id ELSE NULL END) / 
		COUNT(DISTINCT CASE WHEN product_id = 4 THEN i.order_item_id ELSE NULL END) AS p4_refund_rt
FROM order_items AS i
	LEFT JOIN order_item_refunds AS r
		On i.order_item_id = r.order_item_id
WHERE i.created_at < '2014-10-15'
GROUP BY 1, 2
;