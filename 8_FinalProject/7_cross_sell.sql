/*
We made our 4th product available as a primary product on December 05, 2014 (it was previously only a cross-sell
item). Could you please pull sales data since then, and show how well each product cross-sells from one another?
*/
WITH primary_product AS(
SELECT
	order_item_id,
    i.order_id,
    product_id,
    is_primary_item,
    primary_product_id
FROM order_items AS i
	LEFT JOIN orders AS o
		ON i.order_id = o.order_id
WHERE i.created_at > '2014-12-05'
)
SELECT
	primary_product_id AS primary_product,
    COUNT(DISTINCT order_id) AS total_orders,
	COUNT(DISTINCT CASE WHEN product_id = 1 AND is_primary_item = 0 THEN order_id ELSE NULL END) AS _xsold_p1,
	COUNT(DISTINCT CASE WHEN product_id = 2 AND is_primary_item = 0 THEN order_id ELSE NULL END) AS _xsold_p2,
	COUNT(DISTINCT CASE WHEN product_id = 3 AND is_primary_item = 0 THEN order_id ELSE NULL END) AS _xsold_p3,
	COUNT(DISTINCT CASE WHEN product_id = 4 AND is_primary_item = 0 THEN order_id ELSE NULL END) AS _xsold_p4,
    COUNT(DISTINCT CASE WHEN product_id = 1 AND is_primary_item = 0 THEN order_id ELSE NULL END) / COUNT(DISTINCT order_id) AS p1_xsell_rt,
    COUNT(DISTINCT CASE WHEN product_id = 1 AND is_primary_item = 0 THEN order_id ELSE NULL END) / COUNT(DISTINCT order_id) AS p2_xsell_rt,
    COUNT(DISTINCT CASE WHEN product_id = 1 AND is_primary_item = 0 THEN order_id ELSE NULL END) / COUNT(DISTINCT order_id) AS p3_xsell_rt,
    COUNT(DISTINCT CASE WHEN product_id = 1 AND is_primary_item = 0 THEN order_id ELSE NULL END) / COUNT(DISTINCT order_id) AS p4_xsell_rt
FROM primary_product
GROUP BY 1
;