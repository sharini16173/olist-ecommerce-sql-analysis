-- Question: Which payment options are used most, and how much money came through each?
-- Meaning: Breaks down customer payment habits across credit cards, vouchers, and bank slips.

SELECT payment_type,
	   count(order_id)as total_transactions,
	   round(sum(payment_value),2)as total_payment_value,
	   round(avg(payment_value),2)as avg_transaction_value
FROM order_payments
WHERE payment_type != 'not_defined'
GROUP BY payment_type
ORDER BY total_transactions DESC
LIMIT 5;
      