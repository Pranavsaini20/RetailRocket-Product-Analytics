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