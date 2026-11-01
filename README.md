# Brazilian E-Commerce (Olist) Marketplace & Customer Behavior Analysis

**Dialect:** SQLite | **Dataset:** Brazilian E-Commerce Public Dataset by Olist (100k+ orders) | **Scope:** 15 Business SQL Queries

An intermediate-to-advanced relational database analysis investigating commercial performance, customer lifetime behavior, logistics bottlenecks, and merchant tiering across 100,000+ real-world Brazilian e-commerce transactions from 2016 to 2018.

---

## Executive Summary & Key Business Takeaways

* **Fulfillment Directly Drives Brand Loyalty & Sentiment:** On-time deliveries average a **4.29 / 5.0 customer satisfaction score**, whereas delayed orders plunge to **2.14 / 5.0**. Preventing logistics delays directly mitigates negative review volume by over 50%.
* **The Retention Dilemma (<3% Repeat Purchase Rate):** Unique buyer tracking reveals that fewer than 3% of customers ever execute a second transaction. The business model is heavily acquisition-dependent; introducing post-purchase win-back campaigns and category bundles is critical to improving Customer Lifetime Value (LTV).
* **Mid-Tier GMV Dominance:** Baskets between $50 and $200 account for over 60% of total Gross Merchandise Value (GMV), with credit cards handling over 75% of total payment volume.
* **Freight Cost Friction on Large Goods:** High-bulk categories (e.g., furniture, heavy construction tools) carry freight-to-price ratios between **35% and 43%**, directly suppressing purchase conversion outside the Southeast macro-region (SP, RJ, MG).

---

## Database Architecture & Entity Relationships

The schema consists of 9 normalized tables structured around customer profiles, commercial order cycles, merchant listings, delivery timestamps, payment methods, and product categories.

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

## Query Catalog & Technical Breakdown

All production SQL scripts are housed inside the [`sql_queries/`](sql_queries/) directory.

| # | Query File | Business Objective | Core SQL Techniques |
|---|---|---|---|
| **01** | [`01_monthly_revenue.sql`](sql_queries/01_monthly_revenue.sql) | Track marketplace monthly gross merchandise trajectory | `strftime()`, `SUM()`, `GROUP BY`, `ORDER BY` |
| **02** | [`02_top_10_categories.sql`](sql_queries/02_top_10_categories.sql) | Identify highest grossing product categories | Multi-table `INNER JOIN`, aggregate aliasing |
| **03** | [`03_avg_delivery_time.sql`](sql_queries/03_avg_delivery_time.sql) | Evaluate delivery transit duration across states | `julianday()`, date difference calculations |
| **04** | [`04_top_payment_methods.sql`](sql_queries/04_top_payment_methods.sql) | Evaluate checkout method preferences by volume & value | Percentage contribution math, conditional aggregation |
| **05** | [`05_orders_by_state.sql`](sql_queries/05_orders_by_state.sql) | Map geographic customer concentration across regions | Multi-table joins, geographic segmentation |
| **06** | [`06_repeat_customers.sql`](sql_queries/06_repeat_customers.sql) | Calculate platform-wide repeat purchase rate | Common Table Expression (CTE), `HAVING COUNT() > 1` |
| **07** | [`07_seller_revenue_vs_avg.sql`](sql_queries/07_seller_revenue_vs_avg.sql) | Benchmark merchant gross sales against platform average | Multi-stage CTE, platform baseline aggregation |
| **08** | [`08_running_monthly_revenue.sql`](sql_queries/08_running_monthly_revenue.sql) | Track cumulative lifetime marketplace GMV | Window Function: `SUM() OVER (ORDER BY month)` |
| **09** | [`09_mom_revenue_growth.sql`](sql_queries/09_mom_revenue_growth.sql) | Measure month-over-month revenue velocity | Window Function: `LAG() OVER ()`, growth percentage math |
| **10** | [`10_top_sellers_by_state.sql`](sql_queries/10_top_sellers_by_state.sql) | Identify highest-earning merchants partitioned by state | Window Function: `DENSE_RANK() OVER (PARTITION BY state)` |
| **11** | [`11_top_3_products_per_category.sql`](sql_queries/11_top_3_products_per_category.sql) | Isolate top 3 volume-driving items per category | Window Function: `ROW_NUMBER() OVER (PARTITION BY category)` |
| **12** | [`12_delivery_performance_vs_reviews.sql`](sql_queries/12_delivery_performance_vs_reviews.sql) | Quantify rating impact of delayed vs on-time fulfillment | `CASE WHEN`, date comparisons, `AVG(review_score)` |
| **13** | [`13_freight_value_ratio.sql`](sql_queries/13_freight_value_ratio.sql) | Flag catalog categories suffering freight friction | Ratio derivation `(freight / price)`, sorting, `LIMIT 10` |
| **14** | [`14_order_value_tiers.sql`](sql_queries/14_order_value_tiers.sql) | Segment basket totals into Low, Mid, and High brackets | Cart rollup CTE, categorical `CASE WHEN` bucketing |
| **15** | [`15_customer_retention_cohort.sql`](sql_queries/15_customer_retention_cohort.sql) | Cohort tracking of first purchase vs re-engagement | Multi-CTE cohort indexation, `MIN(date)`, grouping |

---

## Detailed Findings & Strategic Recommendations

### 1. Operations & Logistics
* **Observation:** Orders shipped to distant northern/northeastern states experience fulfillment windows twice as long as São Paulo and Rio de Janeiro. Late orders consistently receive 1-star and 2-star reviews criticizing transit clarity.
* **Recommendation:** Implement localized fulfillment micro-hubs or partner with regional third-party logistics (3PL) providers to narrow cross-country transit variance.

### 2. Commercial Strategy & Unit Economics
* **Observation:** Furniture, kitchen appliances, and automotive accessories carry disproportionately high freight ratios (>35%), leading to higher cart abandonment and sensitivity to delivery estimates.
* **Recommendation:** Introduce freight subsidy tiers (e.g., free shipping over R$150) or explore flat-rate regional shipping caps subsidized by merchant margin sharing.

### 3. Customer Retention & Growth
* **Observation:** Over 97% of unique buyers never return. Because marketing expenditure is exhausted entirely on new customer acquisition, lifetime value remains low.
* **Recommendation:** Launch automated transactional email flows targeted at 30, 60, and 90 days post-delivery, offering cross-category incentives aligned with the initial purchase category.

---

## Tools & Environment

* **Database Engine:** SQLite 3
* **Interface & Execution:** DB Browser for SQLite / SQLite Studio
* **Dataset:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
