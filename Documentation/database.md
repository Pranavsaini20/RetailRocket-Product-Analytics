# Database and Data Model

## Technology
PostgreSQL was used for relational storage and SQL analysis.

## Source tables
### Events
Fields used include `timestamp`, `visitorid`, `event`, `itemid` and `transactionid`. Event types analyzed include `view`, `addtocart` and `transaction`.

### Item Properties Part 1 and Part 2
The two files contain timestamped properties for items. Properties used in the Power BI model include `categoryid` and `available`.

### Category Tree
Contains category hierarchy information. Category IDs should only be presented as readable category names when a trustworthy mapping is implemented.

## Derived tables
- `Product_Category`: append the property sources, filter to `categoryid`, retain item/category fields and remove duplicate `itemid` values for a unique product-side key.
- `Product_Availability`: extract the availability property and retain item ID and availability.

## Power BI relationships
- `Events[itemid]` → `Product_Category[itemid]`
- `Events[itemid]` → `Product_Availability[itemid]`

These were configured as many-to-one, single-direction relationships, with Events on the many side.

## Considerations
Dimension-side keys should be unique. Joining tables with different grains can multiply rows and distort counts. Since item properties are timestamped, selecting one value per item can hide historical changes; a more advanced model could use effective-date logic or snapshots.
