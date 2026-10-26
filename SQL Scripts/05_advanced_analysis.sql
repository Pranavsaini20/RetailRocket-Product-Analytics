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