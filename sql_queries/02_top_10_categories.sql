-- Question: What are the top 10 best-selling product categories translated into English?
-- Meaning: Finds which catalog sections bring in the most money so anyone can read the names.

SELECT COALESCE(t.product_category_name_english, p.product_category_name, 'Unknown') AS category,
	   COUNT(i.order_item_id) AS items_sold,
	   ROUND(SUM(i.price),2) AS total_revenue
FROM order_items i JOIN orders o 
ON i.order_id = o.order_id
JOIN products p ON i.product_id = p.product_id
LEFT JOIN category_translation t ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 10;