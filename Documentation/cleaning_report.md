# Data Profiling and Cleaning Report

## Preparation steps
1. Imported the Events, Item Properties Part 1, Item Properties Part 2 and Category Tree source tables.
2. Inspected table structures, row counts, event types and relevant keys.
3. Appended the two item-property sources for property extraction.
4. Filtered category properties to create the product-category table.
5. Extracted availability properties into a separate product-availability table.
6. Removed duplicate item IDs from derived product tables where uniqueness was needed for relationships.
7. Checked the relationship design to reduce ambiguous filtering and duplicated event counts.

## Data-quality considerations
- Imported row counts may differ from published source counts if records are missing or the source version differs.
- Item properties are timestamped; one selected value per item may hide historical changes.
- Missing item mappings can leave events without category or availability matches.
- Event rows, distinct users and distinct products are different units of analysis.

## Validation checklist
Validate source row counts, nulls in key fields, duplicate dimension keys, allowed event values, availability values, transaction ID reliability and whether time-aware property logic is needed.

This report describes the preparation approach; it does not claim that every source-data issue has been eliminated.
