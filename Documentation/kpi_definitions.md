# KPI Definitions

| KPI | Current project definition | Interpretation |
|---|---|---|
| Total Users | Distinct count of `visitorid` | Distinct visitors represented |
| Total Events | Count of event rows | Recorded event actions |
| Total Products | Row count of `Product_Category` | Products represented in that derived table |
| Total Transactions | Rows where event = `transaction` | Transaction event rows; not necessarily distinct orders |
| Views | Rows where event = `view` | Product-view events |
| Add to Cart | Rows where event = `addtocart` | Add-to-cart events |
| Conversion Rate | Transactions / Views | Event-count ratio, not necessarily session conversion |
| Cart Abandonment Rate | (Add to Cart − Transactions) / Add to Cart | Simplified event-count proxy |
| Avg Events per User | Total Events / Total Users | Average recorded events per distinct visitor |
| Viewing Users | Distinct visitors with view events | Unique visitors who viewed |
| Add-to-cart Users | Distinct visitors with add-to-cart events | Unique visitors who added to cart |
| Purchasing Users | Distinct visitors with transaction events | Unique visitors with transaction events |
| User Purchase Rate | Purchasing Users / Total Users | Share of represented users with a transaction event |
| Avg Views per Product | Views / Total Products | Average views per represented product |
| Product Purchase Rate | Current measure: Transactions / Add-to-cart events | Event-count ratio; the label should be refined before business use |

## Important cautions
The approximately 0.84% conversion rate and 32.39% product purchase rate use different denominators and are not interchangeable. A robust cart-abandonment measure should match carts and purchases at a consistent user/session/cart grain. If transaction IDs are reliable, order metrics should consider distinct transaction IDs. Values shown in the report are approximate and may change with filters/model changes.
