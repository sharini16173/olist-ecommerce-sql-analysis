-- Question: What is our cumulative running total of revenue month by month?
-- Meaning: Keeps adding each new month's sales to all previous months to show overall growth.

WITH monthly_sales as(
   SELECT 
       strftime('%Y-%m', o.order_purchase_timestamp) as order_month,
       round(sum(oi.price), 2) as revenue
    FROM order_items oi JOIN orders o 
	ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY order_month)
	
SELECT 
    order_month,
    revenue,
    round(sum(revenue) OVER(ORDER BY order_month),2) as running_total
FROM monthly_sales
ORDER BY order_month;