# Brazilian E-Commerce (Olist) SQL Data Analysis

**Dialect:** SQLite | **Dataset:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) | **Scope:** 15 Business SQL Queries across 100k+ Transactions

An end-to-end relational database project analyzing 100,000+ Brazilian e-commerce orders from 2016 to 2018 across 9 normalized tables. The analysis focuses on commercial revenue trajectories, marketplace unit economics, supply chain bottlenecks, and customer cohort retention.

---

## Dataset Reference

* **Source:** [Kaggle — Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
* **Scope:** 100,000+ real anonymized commercial transactions processed between 2016 and 2018 across Brazilian states.
* **Architecture:** 9 normalized relational tables covering customers, order cycles, line items, payments, reviews, products, sellers, geolocation, and category translations.

---

## Entity-Relationship (ER) Diagram

[customers] (customer_id, customer_unique_id, customer_city, customer_state)
            │
            ▼ (customer_id)
         [orders] (order_id, customer_id, order_status, order_purchase_timestamp, order_delivered_customer_date)
            ├───► [order_payments] (order_id, payment_type, payment_value)
            ├───► [order_reviews]  (order_id, review_score)
            │
            ▼ (order_id)
       [order_items] (order_id, product_id, seller_id, shipping_limit_date, price, freight_value)
            ├───► [sellers]  (seller_id, seller_city, seller_state)
            │
            ▼ (product_id)
       [products] ───► [product_category_name_translation]
       
---

### Relational Model & Key Mapping

| Primary Table | Join Target | Foreign Key | Relationship Grain | Analytical Role |
|---|---|---|---|---|
| **`orders`** | `customers` | `customer_id` | N : 1 | Links orders to geographic buyer markets |
| **`orders`** | `order_payments` | `order_id` | 1 : N | Captures split checkouts and payment methods |
| **`orders`** | `order_reviews` | `order_id` | 1 : N | Matches fulfillment timelines to user ratings |
| **`orders`** | `order_items` | `order_id` | 1 : N | Order itemization; grain for basket calculation |
| **`order_items`** | `products` | `product_id` | N : 1 | Resolves product weights, volumes, and categories |
| **`order_items`** | `sellers` | `seller_id` | N : 1 | Identifies fulfillment origins across Brazil |
| **`products`** | `product_category_name_translation` | `product_category_name` | N : 1 | Translates catalog tags into English descriptors |

---

## 5 Key Insights in Plain English

1. **Delivery Delays Cut Customer Satisfaction in Half**  
   When orders arrive on or ahead of the promised delivery date, customers award an average rating of **4.29 out of 5 stars**. When shipments miss their delivery window, ratings collapse to **2.14 stars**, with 1-star reviews surging past 60%. Operational fulfillment speed is the single largest controllable driver of customer sentiment on the platform.

2. **The Marketplace Faces a Severe Customer Retention Deficit (<3%)**  
   Over **97% of unique buyers never place a second order**. Monthly cohort tracking shows steep drop-offs after month 1 across all buyer classes, meaning almost all platform revenue depends on continuously buying new traffic rather than generating repeat business from existing customers.

3. **Mid-Tier Orders Drive the Bulk of Total Revenue**  
   Baskets valued between **$50 and $200 generate more than 60% of total Gross Merchandise Value (GMV)**. While small impulse purchases (<$50) account for a high portion of overall order counts, the middle tier forms the core commercial backbone of the marketplace.

4. **Bulky Categories Suffer Heavy Freight Cost Friction**  
   For large items like furniture, appliances, and construction tools, shipping charges consume **35% to 43% of the item's purchase price**. This freight burden severely suppresses checkout conversion in Northern and Northeastern states located far from main merchant distribution hubs in São Paulo and Rio de Janeiro.

5. **Revenue Is Heavily Clustered in the Southeast Corridor**  
   The state of São Paulo (SP) alone generates over **40% of all platform orders**, followed by Rio de Janeiro (RJ) and Minas Gerais (MG). In contrast, transit to distant northern states takes more than double the transit time, creating significant logistics friction outside the central economic corridor.

---

## Query Catalog (15 Business Analyses)

All SQL scripts are stored in the [`sql_queries/`](sql_queries/) folder.

| # | File Name | Business Question | SQL Techniques Used |
|---|---|---|---|
| 01 | [`01_monthly_revenue.sql`](sql_queries/01_monthly_revenue.sql) | Monthly gross sales growth trajectory | `strftime()`, `SUM()`, `GROUP BY` |
| 02 | [`02_top_10_categories.sql`](sql_queries/02_top_10_categories.sql) | Top 10 product categories by total sales | Multi-table `JOIN`, aggregate aliasing |
| 03 | [`03_avg_delivery_time.sql`](sql_queries/03_avg_delivery_time.sql) | Average transit duration in days per state | `julianday()`, date arithmetic |
| 04 | [`04_top_payment_methods.sql`](sql_queries/04_top_payment_methods.sql) | Breakdown of payment methods by volume and value | Aggregation, percentage math |
| 05 | [`05_orders_by_state.sql`](sql_queries/05_orders_by_state.sql) | Order and customer regional distribution | Multi-table joins, geographic grouping |
| 06 | [`06_repeat_customers.sql`](sql_queries/06_repeat_customers.sql) | Platform-wide repeat customer purchase percentage | CTE, `customer_unique_id`, `HAVING` |
| 07 | [`07_seller_revenue_vs_avg.sql`](sql_queries/07_seller_revenue_vs_avg.sql) | Seller revenue benchmarked against marketplace average | Multi-stage CTE, baseline comparison |
| 08 | [`08_running_monthly_revenue.sql`](sql_queries/08_running_monthly_revenue.sql) | Cumulative running sales over time | Window function: `SUM() OVER ()` |
| 09 | [`09_mom_revenue_growth.sql`](sql_queries/09_mom_revenue_growth.sql) | Month-over-month revenue growth velocity | Window function: `LAG() OVER ()` |
| 10 | [`10_top_sellers_by_state.sql`](sql_queries/10_top_sellers_by_state.sql) | Highest-earning sellers ranked by state | Window function: `DENSE_RANK() OVER ()` |
| 11 | [`11_top_3_products_per_category.sql`](sql_queries/11_top_3_products_per_category.sql) | Top 3 revenue-generating items in each category | Window function: `ROW_NUMBER() OVER ()` |
| 12 | [`12_delivery_performance_vs_reviews.sql`](sql_queries/12_delivery_performance_vs_reviews.sql) | Rating comparison of late vs on-time deliveries | `CASE WHEN`, `AVG(review_score)` |
| 13 | [`13_freight_value_ratio.sql`](sql_queries/13_freight_value_ratio.sql) | Product categories with the highest shipping burden | Derived ratios, `ORDER BY DESC`, `LIMIT` |
| 14 | [`14_order_value_tiers.sql`](sql_queries/14_order_value_tiers.sql) | Basket segmentation: Low (<$50), Mid ($50–$200), High (>$200) | CTE cart rollup, `CASE WHEN` bucketing |
| 15 | [`15_customer_retention_cohort.sql`](sql_queries/15_customer_retention_cohort.sql) | Customer cohort repeat purchase rates over time | Multi-CTE cohort indexing, `MIN(date)` |

---

## What I Learned (Technical & Analytical Takeaways)

1. **Table Grain & Data Modeling Realities:**  
   In relational databases, verifying table granularity before writing joins is non-negotiable. I learned how `order_items` operates at the item grain rather than the order grain, requiring pre-aggregation or distinct handling to avoid duplicate counts during billing calculations.

2. **Resolving ID Distinctions (`customer_id` vs `customer_unique_id`):**  
   A critical insight was recognizing that Olist generates a new `customer_id` for every transaction session, whereas `customer_unique_id` tracks the individual person. Conducting repeat customer calculations or cohort analyses on `customer_id` would report a false 0% retention rate; grouping by `customer_unique_id` is essential for accurate customer lifetime analysis.

3. **Advanced SQL for Analytical Efficiency:**  
   Mastered Common Table Expressions (CTEs) to segment multi-step analytical problems logically. Gained practical experience implementing window functions (`LAG` for trend differences, `DENSE_RANK` to avoid rank gaps during ties, and `ROW_NUMBER` for top-N ranking per partition) rather than relying on expensive self-joins.

4. **Date Arithmetic in SQLite:**  
   Learned to handle string-stored timestamps using SQLite-specific functions like `julianday()` to compute day differences accurately and `strftime('%Y-%m', ...)` to aggregate monthly financial periods.

5. **Connecting Queries to Business Action:**  
   Writing SQL is only half the analyst's role. Learned to translate metric calculations—such as freight ratios and delivery delay deltas—into concrete commercial recommendations around fulfillment regionalization, post-purchase email re-engagement flows, and dynamic shipping subsidies.

---

## Tools Used

* **Database Engine:** SQLite 3
* **Interface & Execution:** DB Browser for SQLite
* **Modeling & Documentation:** GitHub Markdown, Mermaid.js
* **Dataset Source:** [Olist Public E-Commerce Repository](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
