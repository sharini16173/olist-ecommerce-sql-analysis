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
