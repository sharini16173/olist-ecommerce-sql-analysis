-- Question: How many individual customers made more than one purchase on the platform?
-- Meaning: Checks customer loyalty by counting people who ordered at least twice.

WITH customer_order_count as(
    SELECT 
	    customer_unique_id,
		count(customer_id)as order_count
	FROM customers
	GROUP BY customer_unique_id)
	
SELECT 
    count(customer_unique_id)as total_repeat_customers,
	sum(order_count)as total_orders_from_repeat_buyers
FROM customer_order_count
WHERE order_count>1;