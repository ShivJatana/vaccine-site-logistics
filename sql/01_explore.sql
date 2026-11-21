-- =====================================================================
-- PART 1: EXPLORE THE DATA
-- Database: vaccine_logistics.db (SQLite) - build it first with 00_create_database.sql
-- Run each query in DB Browser for SQLite -> "Execute SQL" tab.
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1.0  How big is each table?
-- ---------------------------------------------------------------------
SELECT 'sites' AS table_name, COUNT(*) AS row_count FROM sites
UNION ALL SELECT 'items', COUNT(*) FROM items
UNION ALL SELECT 'suppliers', COUNT(*) FROM suppliers
UNION ALL SELECT 'daily_site_operations', COUNT(*) FROM daily_site_operations
UNION ALL SELECT 'daily_inventory', COUNT(*) FROM daily_inventory
UNION ALL SELECT 'deliveries', COUNT(*) FROM deliveries
UNION ALL SELECT 'responder_shifts', COUNT(*) FROM responder_shifts;


-- ---------------------------------------------------------------------
-- 1.1  Date range and number of site-days of operation
-- Result: 2021-04-08 to 2021-08-26, 1,921 site-days
-- ---------------------------------------------------------------------
SELECT MIN(op_date) AS first_day,
       MAX(op_date) AS last_day,
       COUNT(*)     AS site_days
FROM daily_site_operations;


-- ---------------------------------------------------------------------
-- 1.2  Doses given by region
-- Result: Peel 75,702 | Toronto 73,072 | York 57,102 | Durham 34,098 | Halton 27,887
-- ---------------------------------------------------------------------
SELECT s.region,
       COUNT(DISTINCT s.site_id)   AS sites,
       SUM(o.doses_administered)   AS doses_given
FROM daily_site_operations AS o
JOIN sites AS s ON s.site_id = o.site_id
GROUP BY s.region
ORDER BY doses_given DESC;


-- ---------------------------------------------------------------------
-- 1.3  Top 5 sites by doses given
-- Result: Malton Mobile clinic leads with 17,486 doses
-- ---------------------------------------------------------------------
SELECT s.site_name,
       s.region,
       s.site_type,
       SUM(o.doses_administered) AS doses_given
FROM daily_site_operations AS o
JOIN sites AS s ON s.site_id = o.site_id
GROUP BY s.site_id
ORDER BY doses_given DESC
LIMIT 5;


-- ---------------------------------------------------------------------
-- 1.4  Saturday vs weekday demand
-- Result: Saturday 204.5 vs weekday 148.9 clients per site per day (+37%)
-- ---------------------------------------------------------------------
SELECT CASE WHEN strftime('%w', op_date) = '6' THEN 'Saturday' ELSE 'Weekday' END AS day_type,
       ROUND(AVG(clients_requesting), 1) AS avg_clients_requesting
FROM daily_site_operations
GROUP BY day_type;


-- ---------------------------------------------------------------------
-- 1.5  Clients turned away by month
-- Result: June was worst at 15.1%; overall 11.8%
-- ---------------------------------------------------------------------
SELECT strftime('%Y-%m', op_date)  AS month,
       SUM(clients_requesting)     AS clients_requesting,
       SUM(doses_administered)     AS doses_given,
       SUM(clients_turned_away)    AS turned_away,
       ROUND(100.0 * SUM(clients_turned_away) / SUM(clients_requesting), 1) AS turned_away_pct
FROM daily_site_operations
GROUP BY month
ORDER BY month;


-- ---------------------------------------------------------------------
-- 1.6  Surge period (Jun 14 - Jul 17) vs the rest
-- Result: turned away 18.6% during the surge vs 7.3% otherwise
-- ---------------------------------------------------------------------
SELECT CASE WHEN op_date BETWEEN '2021-06-14' AND '2021-07-17' THEN 'Surge' ELSE 'Normal' END AS period,
       ROUND(AVG(clients_requesting), 1) AS avg_clients_requesting,
       ROUND(100.0 * SUM(clients_turned_away) / SUM(clients_requesting), 1) AS turned_away_pct
FROM daily_site_operations
GROUP BY period;
