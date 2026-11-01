-- Question: What are the top 3 highest-earning products in every category?
-- Meaning: Pulls the 3 bestsellers per department so we know what items sells best.

WITH product_totals as (
    SELECT 
        coalesce(t.product_category_name_english, p.product_category_name, 'Unknown') as category,
        p.product_id,
        round(sum(oi.price), 2) as total_sales
    FROM order_items oi JOIN products p 
	ON oi.product_id = p.product_id
    JOIN orders o ON oi.order_id = o.order_id
    LEFT JOIN category_translation t ON p.product_category_name = t.product_category_name
    WHERE o.order_status = 'delivered'
    GROUP BY category ,p.product_id),
	
    ranked_products as(SELECT category,
                             product_id,
                             total_sales,
     ROW_NUMBER() OVER(partition by category 
     ORDER BY total_sales desc)as category_rank
     FROM product_totals)
	   
SELECT category, product_id,total_sales,category_rank
FROM ranked_products
WHERE category_rank <=3;