-- Question: How are our customer orders split across small, medium, and large spending amounts?
-- Meaning: Groups each order's bill into Low, Mid, or High buckets to show order counts and revenue per tier.

WITH order_totals as (
    SELECT order_id,
           sum(price) as cart_value
    FROM order_items
    GROUP BY order_id)
	
SELECT 
    CASE 
        WHEN cart_value < 50 THEN '1.Low (< $50)'
        WHEN cart_value between 50 and 200 THEN '2.Mid ($50 - $200)'
        ELSE '3.High(> $200)'
    END as spend_tier,
    count(order_id) as total_orders,
    round(sum(cart_value), 2) as total_revenue
FROM order_totals
GROUP BY spend_tier
ORDER BY spend_tier;