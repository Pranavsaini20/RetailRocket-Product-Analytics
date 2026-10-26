/*
===============================================================================
Project      : RetailRocket Product Analytics Platform
Author       : Pranav Saini
Database     : PostgreSQL

Phase        : 02 - Data Profiling

Description  :
This script explores the dataset and answers fundamental questions about
users, products, events, categories and data quality before analysis.

===============================================================================
*/

-- ============================================================================
-- Section A : Dataset Overview
-- ============================================================================

-- Q1. How many unique users have interacted with the platform?

SELECT COUNT(DISTINCT visitorid) AS total_unique_users
FROM events_raw;

-- Q2. How many unique products are available in our dataset?
SELECT COUNT(DISTINCT itemid) AS total_unique_products
FROM
(
    SELECT itemid
    FROM item_properties_part1_raw

    UNION

    SELECT itemid
    FROM item_properties_part2_raw
) AS products;

-- Q3. How many total user interactions are recorded on the platform?
SELECT event,
       COUNT(*) AS total_events
FROM events_raw
GROUP BY event;


-- Q4. What is the distribution of user events on the platform? Show the count and percentage of each event type.
SELECT
    event,
    COUNT(*) AS total_events,
    ROUND(
        (COUNT(*) * 100.0) / SUM(COUNT(*)) OVER(),
        2
    ) AS percentage_of_events
FROM events_raw
GROUP BY event;

-- Q5.What is the time period covered by the dataset?

SELECT
    MIN(TO_TIMESTAMP(timestamp / 1000.0)) AS earliest_date,
    MAX(TO_TIMESTAMP(timestamp / 1000.0)) AS latest_date,
    (
        MAX(TO_TIMESTAMP(timestamp / 1000.0))
        -
        MIN(TO_TIMESTAMP(timestamp / 1000.0))
    ) AS dataset_duration
FROM events_raw;

-- Q6.Are there any duplicate user events recorded in the events_raw table?

SELECT
    timestamp,
    visitorid,
    event,
    itemid,
    transactionid,
    COUNT(*) AS total_count
FROM events_raw
GROUP BY
    timestamp,
    visitorid,
    event,
    itemid,
    transactionid
HAVING COUNT(*) > 1;


-- Q7.Identify the number of unique users who have only performed view events throughout the entire dataset and have never performed an addtocart or transaction event.

SELECT
    COUNT(DISTINCT visitorid) AS view_only_users
FROM events_raw
WHERE event = 'view'
AND visitorid NOT IN
(
    SELECT DISTINCT visitorid
    FROM events_raw
    WHERE event IN ('addtocart', 'transaction')
);

-- Q8.Identify the number of unique users who added at least one product to their cart but never completed a purchase.

SELECT
    COUNT(DISTINCT visitorid) AS cart_abandonment_users
FROM events_raw
WHERE event = 'addtocart'
AND visitorid NOT IN
(
    SELECT DISTINCT visitorid
    FROM events_raw
    WHERE event = 'transaction'
);

-- Q9.Identify the number of unique users who completed at least one purchase (transaction) during the entire period covered by the dataset.

SELECT
    COUNT(DISTINCT visitorid) AS purchasing_users
FROM events_raw
WHERE event = 'transaction';


-- Q10Identify the Top 10 most viewed products on the platform based on the total number of view events.

SELECT
    itemid,
    COUNT(*) AS total_views
FROM events_raw
WHERE event = 'view'
GROUP BY itemid
ORDER BY total_views DESC
LIMIT 10;


-- Q11.Identify the Top 10 products that were added to the cart the most.

SELECT
    itemid,
    COUNT(*) AS total_addtocart
FROM events_raw
WHERE event = 'addtocart'
GROUP BY itemid
ORDER BY total_addtocart DESC
LIMIT 10;



-- Q12.Identify the Top 10 most purchased products on the platform based on the total number of transaction events.

SELECT
    itemid,
    COUNT(*) AS total_Purchases
FROM events_raw
WHERE event = 'transaction'
GROUP BY itemid
ORDER BY total_Purchases DESC
LIMIT 10;


-- Q13.Identify the Top 10 products with the highest View-to-Add-to-Cart Conversion Rate.
SELECT
    itemid,
    COUNT(CASE WHEN event = 'view' THEN 1 END) AS total_views,
    COUNT(CASE WHEN event = 'addtocart' THEN 1 END) AS total_add_to_cart,
    ROUND(
        COUNT(CASE WHEN event = 'addtocart' THEN 1 END) * 100.0 /
        NULLIF(COUNT(CASE WHEN event = 'view' THEN 1 END), 0),
        2
    ) AS view_to_cart_conversion_rate
FROM events_raw
GROUP BY itemid
HAVING COUNT(CASE WHEN event = 'view' THEN 1 END) > 0
ORDER BY view_to_cart_conversion_rate DESC
LIMIT 10;

-- Q14.Identify the Top 10 products with the highest Add-to-Cart-to-Purchase Conversion Rate.

SELECT
    itemid,
    COUNT(CASE WHEN event = 'addtocart' THEN 1 END) AS total_add_to_cart,
    COUNT(CASE WHEN event = 'transaction' THEN 1 END) AS total_purchases,
    ROUND(
        COUNT(CASE WHEN event = 'transaction' THEN 1 END) * 100.0 /
        NULLIF(COUNT(CASE WHEN event = 'addtocart' THEN 1 END), 0),
        2
    ) AS cart_to_purchase_conversion_rate
FROM events_raw
GROUP BY itemid
HAVING COUNT(CASE WHEN event = 'addtocart' THEN 1 END) > 0
ORDER BY cart_to_purchase_conversion_rate DESC
LIMIT 10;

-- Q15.Identify the Top 10 products with the highest overall View-to-Purchase Conversion Rate.

SELECT
    itemid,
    COUNT(CASE WHEN event = 'view' THEN 1 END) AS total_views,
    COUNT(CASE WHEN event = 'transaction' THEN 1 END) AS total_purchases,
    ROUND(
        COUNT(CASE WHEN event = 'transaction' THEN 1 END) * 100.0 /
        NULLIF(COUNT(CASE WHEN event = 'view' THEN 1 END), 0),
        2
    ) AS overall_conversion_rate
FROM events_raw
GROUP BY itemid
HAVING COUNT(CASE WHEN event = 'view' THEN 1 END) > 0
ORDER BY overall_conversion_rate DESC
LIMIT 10;

-- Q16.Identify the Top 10 products with the highest number of unique viewers.

SELECT
    itemid,
    COUNT(DISTINCT visitorid) AS unique_viewers
FROM events_raw
WHERE event = 'view'
GROUP BY itemid
ORDER BY unique_viewers DESC
LIMIT 10;

-- Q17.dentify the Top 10 products with the highest number of unique purchasers.

SELECT
    itemid,
    COUNT(DISTINCT visitorid) AS unique_purchasers
FROM events_raw
WHERE event = 'transaction'
GROUP BY itemid
ORDER BY unique_purchasers DESC
LIMIT 10;

-- Q18.Identify the Top 10 products with the highest cart abandonment count.

SELECT
    itemid,
    COUNT(CASE WHEN event = 'addtocart' THEN 1 END) AS total_add_to_cart,
    COUNT(CASE WHEN event = 'transaction' THEN 1 END) AS total_purchases,
    (
        COUNT(CASE WHEN event = 'addtocart' THEN 1 END)
        -
        COUNT(CASE WHEN event = 'transaction' THEN 1 END)
    ) AS abandoned_carts
FROM events_raw
GROUP BY itemid
HAVING COUNT(CASE WHEN event = 'addtocart' THEN 1 END) > 0
ORDER BY abandoned_carts DESC
LIMIT 10;

-- Q19.Identify users who purchased more than one product (Repeat Buyers).

SELECT
    visitorid,
    COUNT(DISTINCT itemid) AS unique_products_purchased
FROM events_raw
WHERE event = 'transaction'
GROUP BY visitorid
HAVING COUNT(DISTINCT itemid) > 1
ORDER BY unique_products_purchased DESC;

-- Q20.Identify the Top 10 most active users based on total interactions.

SELECT
    visitorid,
    COUNT(*) AS total_interactions
FROM events_raw
GROUP BY visitorid
ORDER BY total_interactions DESC
LIMIT 10;


-- Q21.Find the average number of interactions per user.

SELECT
    ROUND(AVG(total_interactions),2) AS avg_interactions_per_user
FROM
(
    SELECT
        visitorid,
        COUNT(*) AS total_interactions
    FROM events_raw
    GROUP BY visitorid
) t;

-- Q22.Find the average number of product views per product.

SELECT
    ROUND(AVG(total_views),2) AS avg_views_per_product
FROM
(
    SELECT
        itemid,
        COUNT(*) AS total_views
    FROM events_raw
    WHERE event='view'
    GROUP BY itemid
) t;

-- ============================================================================
-- Business Question 23
-- Requirement:
-- Identify the Top 10 products with the highest total user interactions
-- (Views + Add-to-Cart + Purchases).
-- ============================================================================

SELECT
    itemid,
    COUNT(*) AS total_interactions
FROM events_raw
GROUP BY itemid
ORDER BY total_interactions DESC
LIMIT 10;



-- ============================================================================
-- Business Question 24
-- Requirement:
-- Identify the Top 10 users with the highest number of purchases.
-- ============================================================================

SELECT
    visitorid,
    COUNT(*) AS total_purchases
FROM events_raw
WHERE event = 'transaction'
GROUP BY visitorid
ORDER BY total_purchases DESC
LIMIT 10;



-- ============================================================================
-- Business Question 25
-- Requirement:
-- Find the percentage of users who made at least one purchase.
-- ============================================================================

SELECT
ROUND(
(
COUNT(DISTINCT CASE WHEN event='transaction' THEN visitorid END)*100.0
/
COUNT(DISTINCT visitorid)
),2
) AS purchase_conversion_rate
FROM events_raw;



-- ============================================================================
-- Business Question 26
-- Requirement:
-- Find the percentage of users who added at least one product to cart.
-- ============================================================================

SELECT
ROUND(
(
COUNT(DISTINCT CASE WHEN event='addtocart' THEN visitorid END)*100.0
/
COUNT(DISTINCT visitorid)
),2
) AS add_to_cart_rate
FROM events_raw;



-- ============================================================================
-- Business Question 27
-- Requirement:
-- Find the percentage of users who viewed at least one product.
-- ============================================================================

SELECT
ROUND(
(
COUNT(DISTINCT CASE WHEN event='view' THEN visitorid END)*100.0
/
COUNT(DISTINCT visitorid)
),2
) AS product_view_rate
FROM events_raw;



-- ============================================================================
-- Business Question 28
-- Requirement:
-- Identify the Top 10 products purchased by the highest number
-- of unique customers.
-- ============================================================================

SELECT
    itemid,
    COUNT(DISTINCT visitorid) AS unique_customers
FROM events_raw
WHERE event='transaction'
GROUP BY itemid
ORDER BY unique_customers DESC
LIMIT 10;



-- ============================================================================
-- Business Question 29
-- Requirement:
-- Find the busiest day based on total user interactions.
-- ============================================================================

SELECT
    DATE(TO_TIMESTAMP(timestamp/1000.0)) AS interaction_date,
    COUNT(*) AS total_events
FROM events_raw
GROUP BY interaction_date
ORDER BY total_events DESC
LIMIT 1;



-- ============================================================================
-- Business Question 30
-- Requirement:
-- Find the busiest month based on total user interactions.
-- ============================================================================

SELECT
    DATE_TRUNC('month',TO_TIMESTAMP(timestamp/1000.0)) AS month,
    COUNT(*) AS total_events
FROM events_raw
GROUP BY month
ORDER BY total_events DESC
LIMIT 1;



-- ============================================================================
-- Business Question 31
-- Requirement:
-- Identify the Top 10 days with the highest purchases.
-- ============================================================================

SELECT
    DATE(TO_TIMESTAMP(timestamp/1000.0)) AS purchase_day,
    COUNT(*) AS total_purchases
FROM events_raw
WHERE event='transaction'
GROUP BY purchase_day
ORDER BY total_purchases DESC
LIMIT 10;



-- ============================================================================
-- Business Question 32
-- Requirement:
-- Find the average number of purchases made per purchasing user.
-- ============================================================================

SELECT
ROUND(AVG(total_purchase),2) AS avg_purchase_per_user
FROM
(
    SELECT
        visitorid,
        COUNT(*) AS total_purchase
    FROM events_raw
    WHERE event='transaction'
    GROUP BY visitorid
)t;



-- ============================================================================
-- Business Question 33
-- Requirement:
-- Find the average number of Add-to-Cart events per user.
-- ============================================================================

SELECT
ROUND(AVG(total_cart),2) AS avg_cart_per_user
FROM
(
    SELECT
        visitorid,
        COUNT(*) AS total_cart
    FROM events_raw
    WHERE event='addtocart'
    GROUP BY visitorid
)t;



-- ============================================================================
-- Business Question 34
-- Requirement:
-- Find the average number of product views per user.
-- ============================================================================

SELECT
ROUND(AVG(total_views),2) AS avg_views_per_user
FROM
(
    SELECT
        visitorid,
        COUNT(*) AS total_views
    FROM events_raw
    WHERE event='view'
    GROUP BY visitorid
)t;



-- ============================================================================
-- Business Question 35
-- Requirement:
-- Find the Top 10 products with the lowest View-to-Purchase
-- conversion rate.
-- ============================================================================

SELECT
    itemid,
    COUNT(CASE WHEN event='view' THEN 1 END) AS total_views,
    COUNT(CASE WHEN event='transaction' THEN 1 END) AS total_purchases,
    ROUND(
        COUNT(CASE WHEN event='transaction' THEN 1 END)*100.0/
        NULLIF(COUNT(CASE WHEN event='view' THEN 1 END),0),2
    ) AS conversion_rate
FROM events_raw
GROUP BY itemid
HAVING COUNT(CASE WHEN event='view' THEN 1 END)>0
ORDER BY conversion_rate
LIMIT 10;

-- ============================================================================
-- Business Question 36
-- Requirement:
-- Rank the Top 10 products by total purchases using DENSE_RANK().
-- ============================================================================

WITH product_purchases AS
(
    SELECT
        itemid,
        COUNT(*) AS total_purchases
    FROM events_raw
    WHERE event = 'transaction'
    GROUP BY itemid
)

SELECT
    itemid,
    total_purchases,
    DENSE_RANK() OVER (ORDER BY total_purchases DESC) AS purchase_rank
FROM product_purchases
LIMIT 10;



-- ============================================================================
-- Business Question 37
-- Requirement:
-- Rank the Top 10 most viewed products using ROW_NUMBER().
-- ============================================================================

WITH product_views AS
(
    SELECT
        itemid,
        COUNT(*) AS total_views
    FROM events_raw
    WHERE event = 'view'
    GROUP BY itemid
)

SELECT
    itemid,
    total_views,
    ROW_NUMBER() OVER (ORDER BY total_views DESC) AS view_rank
FROM product_views
LIMIT 10;



-- ============================================================================
-- Business Question 38
-- Requirement:
-- Find the Top 10 users based on total interactions using RANK().
-- ============================================================================

WITH user_activity AS
(
    SELECT
        visitorid,
        COUNT(*) AS total_interactions
    FROM events_raw
    GROUP BY visitorid
)

SELECT
    visitorid,
    total_interactions,
    RANK() OVER (ORDER BY total_interactions DESC) AS activity_rank
FROM user_activity
LIMIT 10;



-- ============================================================================
-- Business Question 39
-- Requirement:
-- Find monthly user interaction trends.
-- ============================================================================

SELECT
    DATE_TRUNC('month', TO_TIMESTAMP(timestamp/1000.0)) AS month,
    COUNT(*) AS total_interactions
FROM events_raw
GROUP BY month
ORDER BY month;



-- ============================================================================
-- Business Question 40
-- Requirement:
-- Find monthly purchase trends.
-- ============================================================================

SELECT
    DATE_TRUNC('month', TO_TIMESTAMP(timestamp/1000.0)) AS month,
    COUNT(*) AS total_purchases
FROM events_raw
WHERE event = 'transaction'
GROUP BY month
ORDER BY month;

-- ============================================================================
-- Business Question 41
-- Requirement:
-- Find the Top 10 product categories with the highest number of user interactions.
-- ============================================================================

WITH latest_category AS
(
    SELECT
        itemid,
        value AS categoryid
    FROM item_properties_part1
    WHERE property = 'categoryid'
)

SELECT
    lc.categoryid,
    COUNT(*) AS total_interactions
FROM events_raw e
JOIN latest_category lc
ON e.itemid = lc.itemid
GROUP BY lc.categoryid
ORDER BY total_interactions DESC
LIMIT 10;



-- ============================================================================
-- Business Question 42
-- Requirement:
-- Find the Top 10 categories with the highest number of purchases.
-- ============================================================================

WITH latest_category AS
(
    SELECT
        itemid,
        value AS categoryid
    FROM item_properties_part1
    WHERE property = 'categoryid'
)

SELECT
    lc.categoryid,
    COUNT(*) AS total_purchases
FROM events_raw e
JOIN latest_category lc
ON e.itemid = lc.itemid
WHERE event='transaction'
GROUP BY lc.categoryid
ORDER BY total_purchases DESC
LIMIT 10;



-- ============================================================================
-- Business Question 43
-- Requirement:
-- Find the Top 10 categories with the highest number of views.
-- ============================================================================

WITH latest_category AS
(
    SELECT
        itemid,
        value AS categoryid
    FROM item_properties_part1
    WHERE property='categoryid'
)

SELECT
    lc.categoryid,
    COUNT(*) AS total_views
FROM events_raw e
JOIN latest_category lc
ON e.itemid=lc.itemid
WHERE event='view'
GROUP BY lc.categoryid
ORDER BY total_views DESC
LIMIT 10;



-- ============================================================================
-- Business Question 44
-- Requirement:
-- Find the Top 10 categories with the highest Add-to-Cart events.
-- ============================================================================

WITH latest_category AS
(
    SELECT
        itemid,
        value AS categoryid
    FROM item_properties_part1
    WHERE property='categoryid'
)

SELECT
    lc.categoryid,
    COUNT(*) AS total_add_to_cart
FROM events_raw e
JOIN latest_category lc
ON e.itemid=lc.itemid
WHERE event='addtocart'
GROUP BY lc.categoryid
ORDER BY total_add_to_cart DESC
LIMIT 10;



-- ============================================================================
-- Business Question 45
-- Requirement:
-- Find the Top 10 categories by unique customers.
-- ============================================================================

WITH latest_category AS
(
    SELECT
        itemid,
        value AS categoryid
    FROM item_properties_part1
    WHERE property='categoryid'
)

SELECT
    lc.categoryid,
    COUNT(DISTINCT visitorid) AS unique_customers
FROM events_raw e
JOIN latest_category lc
ON e.itemid=lc.itemid
GROUP BY lc.categoryid
ORDER BY unique_customers DESC
LIMIT 10;

-- ============================================================================
-- Business Question 46
-- Requirement:
-- Find the Top 10 categories with the highest View-to-Purchase
-- conversion rate.
-- ============================================================================

WITH category_events AS
(
    SELECT
        ip.value AS categoryid,
        e.event
    FROM events_raw e
    JOIN item_properties_part1 ip
        ON e.itemid = ip.itemid
    WHERE ip.property = 'categoryid'
)

SELECT
    categoryid,
    COUNT(CASE WHEN event='view' THEN 1 END) AS total_views,
    COUNT(CASE WHEN event='transaction' THEN 1 END) AS total_purchases,
    ROUND(
        COUNT(CASE WHEN event='transaction' THEN 1 END)*100.0/
        NULLIF(COUNT(CASE WHEN event='view' THEN 1 END),0),
        2
    ) AS conversion_rate
FROM category_events
GROUP BY categoryid
HAVING COUNT(CASE WHEN event='view' THEN 1 END) > 0
ORDER BY conversion_rate DESC
LIMIT 10;



-- ============================================================================
-- Business Question 47
-- Requirement:
-- Show the monthly conversion funnel (Views, Add-to-Cart,
-- Purchases) throughout the dataset.
-- ============================================================================

SELECT
    DATE_TRUNC('month', TO_TIMESTAMP(timestamp/1000.0)) AS month,
    COUNT(CASE WHEN event='view' THEN 1 END) AS total_views,
    COUNT(CASE WHEN event='addtocart' THEN 1 END) AS total_add_to_cart,
    COUNT(CASE WHEN event='transaction' THEN 1 END) AS total_purchases
FROM events_raw
GROUP BY month
ORDER BY month;



-- ============================================================================
-- Business Question 48
-- Requirement:
-- Compare the performance of Available vs Unavailable products.
-- ============================================================================

WITH latest_availability AS
(
    SELECT
        itemid,
        value AS availability
    FROM item_properties_part1
    WHERE property='available'
)

SELECT
    availability,
    COUNT(DISTINCT e.itemid) AS total_products,
    COUNT(*) AS total_interactions,
    COUNT(CASE WHEN event='transaction' THEN 1 END) AS total_purchases
FROM events_raw e
JOIN latest_availability la
ON e.itemid = la.itemid
GROUP BY availability;



-- ============================================================================
-- Business Question 49
-- Requirement:
-- Executive KPI Summary.
-- ============================================================================

SELECT

COUNT(DISTINCT visitorid) AS total_users,

COUNT(DISTINCT itemid) AS total_products,

COUNT(*) AS total_events,

COUNT(CASE WHEN event='view' THEN 1 END) AS total_views,

COUNT(CASE WHEN event='addtocart' THEN 1 END) AS total_add_to_cart,

COUNT(CASE WHEN event='transaction' THEN 1 END) AS total_purchases

FROM events_raw;



-- ============================================================================
-- Business Question 50
-- Requirement:
-- Business Health Dashboard KPI.
-- ============================================================================

SELECT

COUNT(DISTINCT visitorid) AS total_users,

COUNT(DISTINCT itemid) AS total_products,

ROUND(
COUNT(DISTINCT CASE WHEN event='transaction' THEN visitorid END)*100.0/
COUNT(DISTINCT visitorid),2
) AS purchase_conversion_rate,

ROUND(
COUNT(DISTINCT CASE WHEN event='addtocart' THEN visitorid END)*100.0/
COUNT(DISTINCT visitorid),2
) AS add_to_cart_rate,

ROUND(
COUNT(DISTINCT CASE WHEN event='view' THEN visitorid END)*100.0/
COUNT(DISTINCT visitorid),2
) AS product_view_rate,

COUNT(CASE WHEN event='transaction' THEN 1 END) AS total_transactions,

COUNT(CASE WHEN event='addtocart' THEN 1 END)
-
COUNT(CASE WHEN event='transaction' THEN 1 END)
AS cart_abandonment

FROM events_raw;