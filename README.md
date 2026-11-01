# Brazilian E-Commerce (Olist) SQL Data Analysis

**Dialect:** SQLite | **Dataset:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) | **Scope:** 15 Business SQL Queries across 100k+ Transactions

An end-to-end relational database project analyzing 100,000+ Brazilian e-commerce orders from 2016 to 2018 across 9 normalized tables. The analysis focuses on commercial revenue trajectories, marketplace unit economics, supply chain bottlenecks, and customer cohort retention.

---

## Dataset Reference

* **Source:** [Kaggle — Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
* **Scope:** 100,000+ real anonymized commercial transactions processed between 2016 and 2018 across Brazilian states.
* **Architecture:** 9 normalized relational tables covering customers, order cycles, line items, payments, reviews, products, sellers, geolocation, and category translations.

---

## Entity-Relationship (ER) Diagram & Data Architecture

```mermaid
erDiagram
    CUSTOMERS ||--o{ ORDERS : "places (1:N via customer_id)"
    ORDERS ||--o{ ORDER_PAYMENTS : "split into (1:N via order_id)"
    ORDERS ||--o{ ORDER_REVIEWS : "evaluated by (1:N via order_id)"
    ORDERS ||--|{ ORDER_ITEMS : "contains (1:N via order_id)"
    SELLERS ||--o{ ORDER_ITEMS : "fulfills (1:N via seller_id)"
    PRODUCTS ||--o{ ORDER_ITEMS : "ordered as (1:N via product_id)"
    PRODUCT_CATEGORY_TRANSLATION ||--o{ PRODUCTS : "translates (1:N via category_name)"

    CUSTOMERS {
        VARCHAR customer_id PK "Per-order unique token"
        VARCHAR customer_unique_id "Permanent human buyer ID"
        VARCHAR customer_city "Customer City"
        VARCHAR customer_state "State abbreviation"
    }

    ORDERS {
        VARCHAR order_id PK "Unique order identifier"
        VARCHAR customer_id FK "References CUSTOMERS"
        VARCHAR order_status "delivered, shipped, canceled, etc."
        TIMESTAMP order_purchase_timestamp "Purchase datetime"
        TIMESTAMP order_delivered_customer_date "Actual delivery datetime"
        TIMESTAMP order_estimated_delivery_date "Promised delivery date"
    }

    ORDER_ITEMS {
        VARCHAR order_id PK,FK "References ORDERS"
        INTEGER order_item_id PK "Line-item index per order"
        VARCHAR product_id FK "References PRODUCTS"
        VARCHAR seller_id FK "References SELLERS"
        TIMESTAMP shipping_limit_date "Seller dispatch deadline"
        DECIMAL price "Item sales price"
        DECIMAL freight_value "Item shipping cost"
    }

    ORDER_PAYMENTS {
        VARCHAR order_id FK "References ORDERS"
        INTEGER payment_sequential "Split payment sequence"
        VARCHAR payment_type "credit_card, boleto, voucher, debit"
        INTEGER payment_installments "Installment count"
        DECIMAL payment_value "Payment amount"
    }

    ORDER_REVIEWS {
        VARCHAR review_id PK "Unique review identifier"
        VARCHAR order_id FK "References ORDERS"
        INTEGER review_score "Rating score (1 to 5)"
        TIMESTAMP review_creation_date "Survey sent date"
        TIMESTAMP review_answer_timestamp "Survey completed date"
    }

    PRODUCTS {
        VARCHAR product_id PK "Unique product token"
        VARCHAR product_category_name FK "Portuguese category slug"
        INTEGER product_photos_qty "Image asset count"
        DECIMAL product_weight_g "Weight in grams"
        DECIMAL product_length_cm "Package length"
        DECIMAL product_height_cm "Package height"
        DECIMAL product_width_cm "Package width"
    }

    SELLERS {
        VARCHAR seller_id PK "Unique merchant token"
        VARCHAR seller_city "Merchant city"
        VARCHAR seller_state "Merchant state"
    }

    PRODUCT_CATEGORY_TRANSLATION {
        VARCHAR product_category_name PK "Portuguese category slug"
        VARCHAR product_category_name_english "English translation"
    }
Relational Model & Key MappingPrimary TableJoin TargetForeign KeyRelationship GrainAnalytical Roleorderscustomerscustomer_idN : 1Links orders to geographic buyer marketsordersorder_paymentsorder_id1 : NCaptures split checkouts and payment methodsordersorder_reviewsorder_id1 : NMatches fulfillment timelines to user ratingsordersorder_itemsorder_id1 : NOrder itemization; grain for basket calculationorder_itemsproductsproduct_idN : 1Resolves product weights, volumes, and categoriesorder_itemssellersseller_idN : 1Identifies fulfillment origins across Brazilproductsproduct_category_name_translationproduct_category_nameN : 1Translates catalog tags into English descriptors5 Key Insights in Plain EnglishDelivery Delays Cut Customer Satisfaction in HalfWhen orders arrive on or ahead of the promised delivery date, customers award an average rating of 4.29 out of 5 stars. When shipments miss their delivery window, ratings collapse to 2.14 stars, with 1-star reviews surging past 60%. Operational fulfillment speed is the single largest controllable driver of customer sentiment on the platform.The Marketplace Faces a Severe Customer Retention Deficit (<3%)Over 97% of unique buyers never place a second order. Monthly cohort tracking shows steep drop-offs after month 1 across all buyer classes, meaning almost all platform revenue depends on continuously buying new traffic rather than generating repeat business from existing customers.Mid-Tier Orders Drive the Bulk of Total RevenueBaskets valued between $50 and $200 generate more than 60% of total Gross Merchandise Value (GMV). While small impulse purchases (<$50) account for a high portion of overall order counts, the middle tier forms the core commercial backbone of the marketplace.Bulky Categories Suffer Heavy Freight Cost FrictionFor large items like furniture, appliances, and construction tools, shipping charges consume 35% to 43% of the item's purchase price. This freight burden severely suppresses checkout conversion in Northern and Northeastern states located far from main merchant distribution hubs in São Paulo and Rio de Janeiro.Revenue Is Heavily Clustered in the Southeast CorridorThe state of São Paulo (SP) alone generates over 40% of all platform orders, followed by Rio de Janeiro (RJ) and Minas Gerais (MG). In contrast, transit to distant northern states takes more than double the transit time, creating significant logistics friction outside the central economic corridor.Query Catalog (15 Business Analyses)All SQL scripts are stored in the sql_queries/ folder.#File NameBusiness QuestionSQL Techniques Used0101_monthly_revenue.sqlMonthly gross sales growth trajectorystrftime(), SUM(), GROUP BY0202_top_10_categories.sqlTop 10 product categories by total salesMulti-table JOIN, aggregate aliasing0303_avg_delivery_time.sqlAverage transit duration in days per statejulianday(), date arithmetic0404_top_payment_methods.sqlBreakdown of payment methods by volume and valueAggregation, percentage math0505_orders_by_state.sqlOrder and customer regional distributionMulti-table joins, geographic grouping0606_repeat_customers.sqlPlatform-wide repeat customer purchase percentageCTE, customer_unique_id, HAVING0707_seller_revenue_vs_avg.sqlSeller revenue benchmarked against marketplace averageMulti-stage CTE, baseline comparison0808_running_monthly_revenue.sqlCumulative running sales over timeWindow function: SUM() OVER ()0909_mom_revenue_growth.sqlMonth-over-month revenue growth velocityWindow function: LAG() OVER ()1010_top_sellers_by_state.sqlHighest-earning sellers ranked by stateWindow function: DENSE_RANK() OVER ()1111_top_3_products_per_category.sqlTop 3 revenue-generating items in each categoryWindow function: ROW_NUMBER() OVER ()1212_delivery_performance_vs_reviews.sqlRating comparison of late vs on-time deliveriesCASE WHEN, AVG(review_score)1313_freight_value_ratio.sqlProduct categories with the highest shipping burdenDerived ratios, ORDER BY DESC, LIMIT1414_order_value_tiers.sqlBasket segmentation: Low (<$50), Mid ($50–$200), High (>$200)CTE cart rollup, CASE WHEN bucketing1515_customer_retention_cohort.sqlCustomer cohort repeat purchase rates over timeMulti-CTE cohort indexing, MIN(date)What I Learned (Technical & Analytical Takeaways)Table Grain & Data Modeling Realities:In relational databases, verifying table granularity before writing joins is non-negotiable. I learned how order_items operates at the item grain rather than the order grain, requiring pre-aggregation or distinct handling to avoid duplicate counts during billing calculations.Resolving ID Distinctions (customer_id vs customer_unique_id):A critical insight was recognizing that Olist generates a new customer_id for every transaction session, whereas customer_unique_id tracks the individual person. Conducting repeat customer calculations or cohort analyses on customer_id would report a false 0% retention rate; grouping by customer_unique_id is essential for accurate customer lifetime analysis.Advanced SQL for Analytical Efficiency:Mastered Common Table Expressions (CTEs) to segment multi-step analytical problems logically. Gained practical experience implementing window functions (LAG for trend differences, DENSE_RANK to avoid rank gaps during ties, and ROW_NUMBER for top-N ranking per partition) rather than relying on expensive self-joins.Date Arithmetic in SQLite:Learned to handle string-stored timestamps using SQLite-specific functions like julianday() to compute day differences accurately and strftime('%Y-%m', ...) to aggregate monthly financial periods.Connecting Queries to Business Action:Writing SQL is only half the analyst's role. Learned to translate metric calculations—such as freight ratios and delivery delay deltas—into concrete commercial recommendations around fulfillment regionalization, post-purchase email re-engagement flows, and dynamic shipping subsidies.Tools UsedDatabase Engine: SQLite 3Interface & Execution: DB Browser for SQLiteModeling & Documentation: GitHub Markdown, Mermaid.jsDataset Source: Olist Public E-Commerce Repository
