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
