/*
===============================================================================
Project      : RetailRocket Product Analytics Platform
Author       : Pranav Saini
Database     : PostgreSQL

Phase        : 01 - Database Setup

Description  :
This script creates the database schema (raw tables) required for the
RetailRocket Product Analytics project.

Dataset:
- events.csv
- item_properties_part1.csv
- item_properties_part2.csv
- category_tree.csv

Created On   : July 2026
Version      : 1.0
===============================================================================
*/

-- ============================================================================
-- Table 1 : events_raw
-- Purpose : Stores every user interaction (view, add to cart, purchase)
-- ============================================================================

CREATE TABLE events_raw (
    timestamp BIGINT NOT NULL,
    visitorid BIGINT NOT NULL,
    event VARCHAR(20) NOT NULL,
    itemid BIGINT NOT NULL,
    transactionid BIGINT NULL
);


-- ============================================================================
-- Table 2 : item_properties_part1_raw
-- Purpose : Stores product properties (Part 1)
-- ============================================================================

CREATE TABLE item_properties_part1_raw (
    timestamp BIGINT NOT NULL,
    itemid BIGINT NOT NULL,
    property VARCHAR(100) NOT NULL,
    value VARCHAR(1000) NOT NULL
);


-- ============================================================================
-- Table 3 : item_properties_part2_raw
-- Purpose : Stores product properties (Part 2)
-- ============================================================================

CREATE TABLE item_properties_part2_raw (
    timestamp BIGINT NOT NULL,
    itemid BIGINT NOT NULL,
    property VARCHAR(100) NOT NULL,
    value VARCHAR(1000) NOT NULL
);


-- ============================================================================
-- Table 4 : category_tree_raw
-- Purpose : Stores category hierarchy
-- ============================================================================

CREATE TABLE category_tree_raw (
    categoryid INT NOT NULL,
    parentid INT NULL
);