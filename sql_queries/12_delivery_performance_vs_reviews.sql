-- Question: How do late deliveries affect customer review ratings compared to on-time ones?
-- Meaning: Checks whether delayed shipping leads directly to bad customer ratings.

SELECT 
    CASE 
        WHEN date(o.order_delivered_customer_date) <= date(o.order_estimated_delivery_date) THEN 'On-Time'
        ELSE 'Late' 
    END as delivery_status,
    count(DISTINCT o.order_id) as total_orders,
    round(avg(r.review_score), 2) as avg_review_score
FROM orders o JOIN order_reviews r 
ON o.order_id = r.order_id
WHERE o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status;

		
		