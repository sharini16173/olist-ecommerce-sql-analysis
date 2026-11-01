-- Question: Which Brazilian states have the highest number of orders and customers?
-- Meaning: Shows where our biggest geographic customer base lives for marketing focus.

SELECT c.customer_state,
	   count(DISTINCT o.order_id)as total_orders,
	   count(DISTINCT c.customer_unique_id)as total_customers
FROM orders o JOIN customers c
ON o.customer_id=c.customer_id
WHERE o.order_status='delivered'
GROUP BY customer_state
ORDER BY total_orders DESC;