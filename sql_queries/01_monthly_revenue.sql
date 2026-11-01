--EXPLORE:

-- Step 1.1: Data Sanity Check - Verify row counts across all 9 tables
SELECT 'orders' AS table_name, COUNT(*) AS row_count FROM orders
UNION ALL
SELECT 'order_items' AS table_name, COUNT(*) AS row_count FROM order_items
UNION ALL
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'order_payments' AS table_name, COUNT(*) AS row_count FROM order_payments
UNION ALL
SELECT 'order_reviews' AS table_name, COUNT(*) AS row_count FROM order_reviews
UNION ALL
SELECT 'products' AS table_name, COUNT(*) AS row_count FROM products
UNION ALL
SELECT 'sellers' AS table_name, COUNT(*) AS row_count FROM sellers
UNION ALL
SELECT 'category_translation' AS table_name, COUNT(*) AS row_count FROM category_translation
UNION ALL
SELECT 'geolocation' AS table_name, COUNT(*) AS row_count FROM geolocation;

-- Step 1.2: Check for missing delivery dates in the orders table
SELECT COUNT(*) AS total_orders,
       COUNT(order_delivered_customer_date) AS delivered_orders,
       COUNT(*) - COUNT(order_delivered_customer_date) AS missing_delivery_dates
FROM orders;

-- Step 1.3: Check how orders link to order_items and count items per order
SELECT o.order_id,
       o.order_status,
       COUNT(oi.order_item_id)as total_items
FROM orders o JOIN order_items oi 
ON o.order_id = oi.order_id
GROUP BY o.order_id,o.order_status
ORDER BY total_items DESC
LIMIT 5;

-- Question: What are our total monthly sales and completed order counts over time?
-- Meaning: Shows monthly cash flow and whether our order volume is going up or down

SELECT 
    strftime('%Y-%m', o.order_purchase_timestamp)as order_month,
    COUNT(DISTINCT o.order_id)as total_orders,
    ROUND(sum(oi.price), 2)as total_revenue
FROM orders o JOIN order_items oi 
ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY order_month
ORDER BY order_month ASC;


 