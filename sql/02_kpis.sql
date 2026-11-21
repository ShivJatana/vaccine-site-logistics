-- =====================================================================
-- PART 2: LOGISTICS KPIs
-- The numbers a logistics supervisor reports up the chain.
-- =====================================================================


-- ---------------------------------------------------------------------
-- 2.0  Site utilization (doses given / capacity)
-- Result: one row per site; across the whole network, utilization is 71.8%
-- ---------------------------------------------------------------------
SELECT s.site_name,
       s.daily_capacity,
       COUNT(*)                                   AS days_open,
       SUM(o.doses_administered)                  AS doses_given,
       ROUND(100.0 * SUM(o.doses_administered)
             / (s.daily_capacity * COUNT(*)), 1)  AS utilization_pct
FROM daily_site_operations AS o
JOIN sites AS s ON s.site_id = o.site_id
GROUP BY s.site_id
ORDER BY utilization_pct DESC;


-- ---------------------------------------------------------------------
-- 2.1  Supplier on-time delivery %
-- Result: NorthPath Medical 58.7% (3.3 days late when late); others 91-93%
-- ---------------------------------------------------------------------
SELECT sp.supplier_name,
       COUNT(*) AS deliveries,
       ROUND(100.0 * SUM(d.delivered_date <= d.expected_date) / COUNT(*), 1) AS on_time_pct,
       ROUND(AVG(julianday(d.delivered_date) - julianday(d.expected_date)), 2) AS avg_days_late,
       ROUND(AVG(CASE WHEN d.delivered_date > d.expected_date
                      THEN julianday(d.delivered_date) - julianday(d.expected_date) END), 1) AS days_late_when_late
FROM deliveries AS d
JOIN suppliers AS sp ON sp.supplier_id = d.supplier_id
GROUP BY sp.supplier_name
ORDER BY on_time_pct;


-- ---------------------------------------------------------------------
-- 2.2  Order fill rate (qty received / qty ordered)
-- Result: every supplier ~98% - short shipments were NOT the problem
-- ---------------------------------------------------------------------
SELECT sp.supplier_name,
       ROUND(100.0 * SUM(d.qty_received) / SUM(d.qty_ordered), 1) AS fill_rate_pct
FROM deliveries AS d
JOIN suppliers AS sp ON sp.supplier_id = d.supplier_id
GROUP BY sp.supplier_name
ORDER BY fill_rate_pct;


-- ---------------------------------------------------------------------
-- 2.3  Stock-out days by item (closing_qty = 0)
-- Result: Surgical masks 184 and Nitrile gloves 151 (both NorthPath);
--         vaccine almost never ran out (17 site-days combined)
-- ---------------------------------------------------------------------
SELECT i.item_name,
       sp.supplier_name,
       SUM(inv.closing_qty = 0) AS stockout_days,
       ROUND(100.0 * SUM(inv.closing_qty = 0) / COUNT(*), 1) AS stockout_pct_of_days
FROM daily_inventory AS inv
JOIN items     AS i  ON i.item_id = inv.item_id
JOIN suppliers AS sp ON sp.supplier_id = i.supplier_id
GROUP BY i.item_id
ORDER BY stockout_days DESC;


-- ---------------------------------------------------------------------
-- 2.4  Vaccine wastage: small vs large sites
-- Result: small sites 5.7% vs large sites 1.5%
-- ---------------------------------------------------------------------
SELECT CASE WHEN s.daily_capacity <= 100 THEN 'Small (<=100/day)' ELSE 'Large' END AS site_size,
       SUM(inv.wasted_qty) AS doses_wasted,
       ROUND(100.0 * SUM(inv.wasted_qty) / SUM(inv.used_qty + inv.wasted_qty), 1) AS wastage_pct
FROM daily_inventory AS inv
JOIN items AS i ON i.item_id = inv.item_id
JOIN sites AS s ON s.site_id = inv.site_id
WHERE i.category = 'Vaccine'
GROUP BY site_size;


-- ---------------------------------------------------------------------
-- 2.5  Why were clients turned away? Capacity vs supplies
-- A client is a "capacity" turn-away if demand exceeded the site's daily
-- capacity; anything beyond that was caused by running out of supplies.
-- Result: 35,899 turned away = 12,675 capacity (35%) + 23,224 supplies (65%);
--         20,338 of the supply turn-aways (88%) were on glove stock-out days
-- ---------------------------------------------------------------------
WITH day_detail AS (
    SELECT o.op_date,
           o.site_id,
           o.clients_turned_away,
           MIN(o.clients_turned_away,
               MAX(0, o.clients_requesting - s.daily_capacity)) AS capacity_turnaways,
           g.closing_qty AS gloves_left
    FROM daily_site_operations AS o
    JOIN sites AS s ON s.site_id = o.site_id
    JOIN daily_inventory AS g
         ON g.inv_date = o.op_date AND g.site_id = o.site_id AND g.item_id = 'ITM05'
)
SELECT SUM(clients_turned_away)                          AS total_turned_away,
       SUM(capacity_turnaways)                           AS due_to_capacity,
       SUM(clients_turned_away - capacity_turnaways)     AS due_to_supplies,
       SUM(CASE WHEN gloves_left = 0
                THEN clients_turned_away - capacity_turnaways ELSE 0 END) AS supplies_on_glove_stockout_days
FROM day_detail;
