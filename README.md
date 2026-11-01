# Brazilian E-Commerce (Olist) SQL Analysis

An intermediate-level relational database analysis of 100,000+ Brazilian e-commerce orders across 9 relational tables using SQLite.

## Database Schema Overview

[customers] (customer_id, customer_unique_id, customer_city, customer_state)
│
▼ (customer_id)
[orders] (order_id, customer_id, order_status, order_purchase_timestamp, order_delivered_customer_date)
├───► (order_id) ───► [order_payments] (order_id, payment_type, payment_value)
├───► (order_id) ───► [order_reviews]  (order_id, review_score)
│
▼ (order_id)
[order_items] (order_id, product_id, seller_id, shipping_limit_date, price, freight_value)
├───► (seller_id)  ───► [sellers]  (seller_id, seller_state)
│
▼ (product_id)
[products] ───► [category_translation]


## Query Catalog (15 Business Questions)

| # | File Name | Question / Focus | Key Technique |
|---|---|---|---|
| 01 | [`01_monthly_revenue.sql`](sql_queries/01_monthly_revenue.sql) | Monthly gross revenue trajectory | `strftime`, `SUM()`, `GROUP BY` |
| 02 | [`02_top_10_categories.sql`](sql_queries/02_top_10_categories.sql) | Top 10 product categories by sales | Multi-table `JOIN`, `SUM()` |
| 03 | [`03_avg_delivery_time.sql`](sql_queries/03_avg_delivery_time.sql) | Average delivery days by customer state | `julianday()`, date difference |
| 04 | [`04_top_payment_methods.sql`](sql_queries/04_top_payment_methods.sql) | Payment method breakdown by volume & value | Aggregation, percentage math |
| 05 | [`05_orders_by_state.sql`](sql_queries/05_orders_by_state.sql) | Revenue and order distribution across states | Multi-table joins, geographic aggregation |
| 06 | [`06_repeat_customers.sql`](sql_queries/06_repeat_customers.sql) | Percentage of repeat buyers across platform | CTE, `customer_unique_id`, `HAVING` |
| 07 | [`07_seller_revenue_vs_avg.sql`](sql_queries/07_seller_revenue_vs_avg.sql) | Sellers performance compared to platform average | Window function / CTE aggregation |
| 08 | [`08_running_monthly_revenue.sql`](sql_queries/08_running_monthly_revenue.sql) | Cumulative running sales over time | Window function: `SUM() OVER ()` |
| 09 | [`09_mom_revenue_growth.sql`](sql_queries/09_mom_revenue_growth.sql) | Month-over-month revenue growth rate | Window function: `LAG() OVER ()` |
| 10 | [`10_top_sellers_by_state.sql`](sql_queries/10_top_sellers_by_state.sql) | Highest grossing sellers in each state | Window function: `DENSE_RANK() OVER ()` |
| 11 | [`11_top_3_products_per_category.sql`](sql_queries/11_top_3_products_per_category.sql) | Top 3 best-selling products per category | Window function: `ROW_NUMBER() OVER ()` |
| 12 | [`12_delivery_performance_vs_reviews.sql`](sql_queries/12_delivery_performance_vs_reviews.sql) | Late vs on-time delivery impact on review ratings | `CASE WHEN`, `AVG(review_score)` |
| 13 | [`13_freight_value_ratio.sql`](sql_queries/13_freight_value_ratio.sql) | Categories with highest shipping burden | Ratio calculation, `LIMIT 10` |
| 14 | [`14_order_value_tiers.sql`](sql_queries/14_order_value_tiers.sql) | Orders split into Low, Mid, and High spend tiers | CTE cart rollup, `CASE WHEN` |
| 15 | [`15_customer_retention_cohort.sql`](sql_queries/15_customer_retention_cohort.sql) | Monthly customer cohort repeat purchase rate | CTE, `MIN()`, conditional aggregation |

## Core Business Findings

1. **Late Deliveries Cut Ratings in Half:** On-time orders average ~4.29 stars, while delayed deliveries drop to ~2.14 stars.
2. **Low Retention Rate:** Less than 3% of customers return to buy again, showing heavy reliance on continuous acquisition.
3. **Mid-Tier GMV Concentration:** Orders between $50 and $200 make up over 60% of total revenue.
4. **Bulky Item Freight Friction:** Large furniture and tools see freight costs reaching 35%–43% of product price.
