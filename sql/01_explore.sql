-- =====================================================================
-- PART 1: EXPLORE THE DATA
-- Database: vaccine_logistics.db (SQLite) - build it first with 00_create_database.sql
-- Open it in DB Browser for SQLite -> "Execute SQL" tab, run one query at a time.
-- Worked examples are complete. Exercises marked TODO are yours to write.
-- =====================================================================


-- ---------------------------------------------------------------------
-- WORKED EXAMPLE 1: How big is each table?
-- ---------------------------------------------------------------------
SELECT 'sites' AS table_name, COUNT(*) AS row_count FROM sites
UNION ALL SELECT 'items', COUNT(*) FROM items
UNION ALL SELECT 'suppliers', COUNT(*) FROM suppliers
UNION ALL SELECT 'daily_site_operations', COUNT(*) FROM daily_site_operations
UNION ALL SELECT 'daily_inventory', COUNT(*) FROM daily_inventory
UNION ALL SELECT 'deliveries', COUNT(*) FROM deliveries
UNION ALL SELECT 'responder_shifts', COUNT(*) FROM responder_shifts;


-- ---------------------------------------------------------------------
-- WORKED EXAMPLE 2: Doses given by region (JOIN + GROUP BY)
-- daily_site_operations has site_id; the region lives in the sites table.
-- ---------------------------------------------------------------------
SELECT s.region,
       COUNT(DISTINCT s.site_id)   AS sites,
       SUM(o.doses_administered)   AS doses_given
FROM daily_site_operations AS o
JOIN sites AS s ON s.site_id = o.site_id
GROUP BY s.region
ORDER BY doses_given DESC;


-- ---------------------------------------------------------------------
-- WORKED EXAMPLE 3: Doses by month (working with dates)
-- SQLite stores dates as text 'YYYY-MM-DD'; strftime pulls out parts.
-- ---------------------------------------------------------------------
SELECT strftime('%Y-%m', op_date) AS month,
       SUM(clients_requesting)    AS clients_requesting,
       SUM(doses_administered)    AS doses_given
FROM daily_site_operations
GROUP BY month
ORDER BY month;


-- ---------------------------------------------------------------------
-- TODO 1.1: What date range does the data cover, and how many
--           site-days of operation are there?
-- Hint: MIN(), MAX(), COUNT(*) on daily_site_operations.
-- ---------------------------------------------------------------------


-- ---------------------------------------------------------------------
-- TODO 1.2: Which 5 sites gave the most doses?
--           Show site_name, region, site_type and total doses.
-- Hint: same JOIN as Example 2, GROUP BY the site, ORDER BY ... DESC LIMIT 5.
-- ---------------------------------------------------------------------


-- ---------------------------------------------------------------------
-- TODO 1.3: Is demand different on Saturdays?
--           Average clients_requesting for Saturday vs Monday-Friday.
-- Hint: strftime('%w', op_date) returns '6' for Saturday.
--       CASE WHEN ... THEN 'Saturday' ELSE 'Weekday' END
-- ---------------------------------------------------------------------


-- ---------------------------------------------------------------------
-- TODO 1.4: How many clients were turned away each month, and what %
--           of clients requesting is that?
-- Hint: 100.0 * SUM(clients_turned_away) / SUM(clients_requesting)
--       (use 100.0, not 100, so SQLite doesn't round to a whole number)
-- ---------------------------------------------------------------------
