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