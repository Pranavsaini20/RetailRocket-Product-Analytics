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