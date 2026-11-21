-- =====================================================================
-- PART 3: FIX THE PROBLEM - REORDER POINTS
-- The sites reordered once a week (Mondays) based on last week's use.
-- This part sets a reorder point and safety stock per item.
--
--   Reorder point = (average daily use x average lead time) + safety stock
--   Safety stock  = (max daily use x max lead time) - (avg daily use x avg lead time)
--
-- The classic "max-min" safety stock formula: simple, conservative, and
-- easy to explain to a site team.
-- =====================================================================


-- ---------------------------------------------------------------------
-- 3.1  Actual lead time per supplier (order -> delivery)
-- Result: NorthPath promised 3 days, averaged 4.4, worst case 8
-- ---------------------------------------------------------------------
SELECT sp.supplier_name,
       sp.promised_lead_time_days,
       ROUND(AVG(julianday(d.delivered_date) - julianday(d.order_date)), 1) AS avg_lead_days,
       MAX(julianday(d.delivered_date) - julianday(d.order_date))           AS max_lead_days
FROM deliveries AS d
JOIN suppliers AS sp ON sp.supplier_id = d.supplier_id
GROUP BY sp.supplier_name
ORDER BY avg_lead_days DESC;


-- ---------------------------------------------------------------------
-- 3.2  Safety stock and reorder point per item at the busiest site
--      (Malton Mobile clinic, S12)
-- Result for nitrile gloves: avg 239/day, max 320/day,
--         safety stock ~1,515 pairs, reorder point ~2,560 pairs
-- ---------------------------------------------------------------------
WITH usage AS (
    SELECT site_id, item_id,
           AVG(used_qty) AS avg_daily_use,
           MAX(used_qty) AS max_daily_use
    FROM daily_inventory
    GROUP BY site_id, item_id
),
lead AS (
    SELECT supplier_id,
           AVG(julianday(delivered_date) - julianday(order_date)) AS avg_lead,
           MAX(julianday(delivered_date) - julianday(order_date)) AS max_lead
    FROM deliveries
    GROUP BY supplier_id
)
SELECT s.site_name,
       i.item_name,
       ROUND(u.avg_daily_use, 1) AS avg_daily_use,
       u.max_daily_use,
       ROUND(l.avg_lead, 1)      AS avg_lead_days,
       l.max_lead                AS max_lead_days,
       ROUND(u.max_daily_use * l.max_lead - u.avg_daily_use * l.avg_lead) AS safety_stock,
       ROUND(u.avg_daily_use * l.avg_lead
             + (u.max_daily_use * l.max_lead - u.avg_daily_use * l.avg_lead)) AS reorder_point
FROM usage AS u
JOIN items AS i ON i.item_id = u.item_id
JOIN lead  AS l ON l.supplier_id = i.supplier_id
JOIN sites AS s ON s.site_id = u.site_id
WHERE s.site_name = 'Malton Mobile clinic'
ORDER BY i.item_id;


-- ---------------------------------------------------------------------
-- 3.3  How did the old weekly-order habit perform for gloves at Malton?
-- Result: average order ~1,500 pairs; stocked out on 9 of 79 days open
-- ---------------------------------------------------------------------
SELECT ROUND(AVG(d.qty_ordered)) AS avg_weekly_order,
       (SELECT SUM(closing_qty = 0) FROM daily_inventory
         WHERE site_id = s.site_id AND item_id = 'ITM05') AS glove_stockout_days,
       (SELECT COUNT(*) FROM daily_site_operations
         WHERE site_id = s.site_id) AS days_open
FROM deliveries AS d
JOIN sites AS s ON s.site_id = d.site_id
WHERE s.site_name = 'Malton Mobile clinic'
  AND d.item_id = 'ITM05';
