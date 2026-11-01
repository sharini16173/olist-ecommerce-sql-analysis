-- Question: Which sellers earned more total revenue than the average platform seller?
-- Meaning: Spots the top merchants who beat the typical seller benchmark.

WITH seller_revenue as(
    SELECT oi.seller_id,
           round(sum(oi.price), 2)as total_revenue
    FROM order_items oi JOIN orders o 
	ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id)
	
SELECT 
    seller_id,
    total_revenue,
    (SELECT round(avg(total_revenue), 2) FROM seller_revenue)as avg_seller_revenue
     FROM seller_revenue
     WHERE total_revenue >(SELECT avg(total_revenue) FROM seller_revenue)
	 
ORDER BY total_revenue DESC;
          