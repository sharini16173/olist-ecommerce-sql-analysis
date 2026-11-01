-- Question: What is our month-over-month (MoM) revenue growth percentage?
-- Meaning: Compares this month's sales against last month to see the jump or drop rate.

WITH monthly_sales as(
    SELECT  
        strftime('%Y-%m', o.order_purchase_timestamp) as order_month,
        round(sum(oi.price), 2) as current_sales
    FROM order_items oi JOIN orders o 
	ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY order_month)
	
SELECT 
    order_month,
    current_sales,
    LAG(current_sales) OVER(ORDER BY order_month) as prev_month_sales,
	round((current_sales - LAG(current_sales) OVER(ORDER BY order_month))*100.0 
        / LAG(current_sales) OVER(ORDER BY order_month),2) as mom_growth_pct
FROM monthly_sales;