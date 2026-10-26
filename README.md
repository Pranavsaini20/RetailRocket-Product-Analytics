# RetailRocket Product Analytics Platform
### Understanding User Behavior, Conversion Funnels & Product Performance with SQL and Power BI

## Overview
This portfolio project analyzes RetailRocket e-commerce behavioral data using PostgreSQL, SQL, Power Query, DAX and Power BI. It focuses on visitor activity, product engagement, category trends and the purchase funnel.

## Objectives
- Analyze views, add-to-cart actions and transaction events.
- Explore user and product/category activity.
- Define KPIs and communicate their definitions clearly.
- Build a four-page Power BI report.
- Translate analysis into practical business recommendations.

## Tools
PostgreSQL · SQL · Microsoft Power BI · Power Query · DAX

## Source data
- `events`: visitor, event type, item, timestamp and transaction fields.
- `item_properties_part1` and `item_properties_part2`: timestamped item properties.
- `category_tree`: category hierarchy.

See `Dataset/README.md` for dataset notes. Large raw files are not included in this documentation pack.

## Workflow
1. Profile source tables.
2. Append item-property sources and extract category/availability properties.
3. Analyze user, product and category behavior in SQL.
4. Define KPIs and their denominators.
5. Build the Power BI data model and report.
6. Summarize findings, recommendations and limitations.

## Dashboard pages
1. **Executive Overview** — headline KPIs, event mix, activity trend and funnel.
2. **User Analytics** — viewing, carting and purchasing users and user activity.
3. **Product Analytics** — availability, product engagement and category/product comparisons.
4. **Executive Insights** — business summary, key findings and recommendations.

## Selected current metrics
| Metric | Approximate value |
|---|---:|
| Total users | 1.41M |
| Total events | 2.76M |
| Products in product-category table | 417K |
| Transaction events | 22K |
| Conversion rate (transactions / views) | 0.84% |
| Cart abandonment proxy | 67.61% |
| Average events per user | 1.96 |
| Average views per product | 6.39 |

**Important:** these figures come from the current report. Conversion, user purchase rate and the project's product purchase rate use different denominators. See `Documentation/kpi_definitions.md`.

## Repository structure
- `SQL Scripts/` — SQL setup, profiling and analysis scripts.
- `Power BI/` — PBIX report or access instructions.
- `Images/` — screenshots of the report pages.
- `Documentation/` — project methods, metrics and findings.
- `Dataset/` — source and data notes.

## Findings and recommendations
The current analysis suggests meaningful user and product activity alongside opportunities to investigate the purchase funnel and cart abandonment. Recommended follow-up includes examining lower-funnel drop-off, reviewing high-view/low-purchase products, checking availability against demand, and segmenting results by product, category and time.

## Limitations and next steps
This is a portfolio analysis, not a live production BI pipeline. Item properties are timestamped; selecting one value per item may hide historical changes. Category IDs are identifiers unless mapped to readable labels. Conversion and abandonment measures should be refined to consistent user/session/cart/order definitions before operational use. Future work could include cohort retention, stronger data-quality tests and automated refresh.
