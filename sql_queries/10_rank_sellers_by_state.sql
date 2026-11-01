-- Question: Who are the top-ranked sellers by revenue inside each state?
-- Meaning: Compares sellers only against their local peers, restarting rank at 1 for every state.

WITH seller_sales as (
    SELECT s.seller_state,
           s.seller_id,
           round(sum(oi.price), 2) as total_sales
    FROM order_items oi JOIN sellers s 
	ON oi.seller_id = s.seller_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY s.seller_state, s.seller_id)
	
SELECT seller_state,
       seller_id,
       total_sales,
     dense_rank() OVER(partition by seller_state 
	 ORDER BY total_sales desc)as state_rank
FROM seller_sales;