-- Question: Which categories have the highest shipping costs compared to item price?
-- Meaning: Flags products where shipping fees are too high relative to the item's cost.

SELECT 
    coalesce(t.product_category_name_english, p.product_category_name, 'Unknown') as category,
    round(avg(oi.price), 2) as avg_price,
    round(avg(oi.freight_value), 2) as avg_shipping,
    round(avg(oi.freight_value) * 100.0 / avg(oi.price), 2) as shipping_percentage
FROM order_items oi JOIN products p 
ON oi.product_id = p.product_id
JOIN category_translation t ON p.product_category_name = t.product_category_name
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY category
ORDER BY shipping_percentage DESC
LIMIT 10;
