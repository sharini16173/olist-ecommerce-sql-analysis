-- Question: How many days on average does it take for an order to reach a customer?
-- Meaning: Measures how fast our shipping process is from checkout to delivery.

SELECT 
    round(avg(julianday(order_delivered_customer_date)- julianday(order_purchase_timestamp)),2)as avg_delivery_days
FROM orders
WHERE order_status='delivered';
