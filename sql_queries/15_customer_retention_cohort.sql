-- Question: What percentage of new buyers in a given month return to buy again later?
-- Meaning: Groups customers by their first purchase month to track long-term repeat buying.

WITH customer_summary AS (
    SELECT 
        c.customer_unique_id,
        MIN(strftime('%Y-%m', o.order_purchase_timestamp)) AS first_month,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM orders o 
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT 
    first_month AS cohort_month,
    COUNT(customer_unique_id) AS total_customers,
    COUNT(CASE WHEN total_orders > 1 THEN 1 END) AS repeat_customers,
    ROUND(COUNT(CASE WHEN total_orders > 1 THEN 1 END) * 100.0 
	/ COUNT(customer_unique_id), 2) AS repeat_rate_pct
FROM customer_summary
GROUP BY first_month
ORDER BY first_month;
