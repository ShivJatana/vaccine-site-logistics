-- =====================================================================
-- PART 2: LOGISTICS KPIs
-- These are the numbers a logistics supervisor reports up the chain.
-- Write each query, then save the result (copy to Excel or export CSV)
-- so you can use it in the dashboard.
-- =====================================================================


-- ---------------------------------------------------------------------
-- WORKED EXAMPLE: Site utilization
-- Utilization = doses given / doses the site could have given (capacity).
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
-- TODO 2.1  SUPPLIER ON-TIME DELIVERY %
--   For each supplier: number of deliveries, % delivered on or before
--   expected_date, and average days late.
-- Hint: SUM(delivered_date <= expected_date) counts on-time rows
--       (a true comparison = 1 in SQLite).
--       Days late: julianday(delivered_date) - julianday(expected_date)
-- ---------------------------------------------------------------------


-- ---------------------------------------------------------------------
-- TODO 2.2  ORDER FILL RATE
--   For each supplier: % of quantity ordered that was actually received.
-- Hint: 100.0 * SUM(qty_received) / SUM(qty_ordered)
-- ---------------------------------------------------------------------


-- ---------------------------------------------------------------------
-- TODO 2.3  STOCK-OUT DAYS BY ITEM
--   A stock-out day = an item's closing_qty is 0 at a site on a date.
--   Count stock-out days per item, and show which supplier provides it.
-- Hint: daily_inventory JOIN items JOIN suppliers; SUM(closing_qty = 0)
-- ---------------------------------------------------------------------


-- ---------------------------------------------------------------------
-- TODO 2.4  VACCINE WASTAGE RATE
--   Wastage % = wasted_qty / (used_qty + wasted_qty), vaccine items only.
--   Compare small sites (daily_capacity <= 100) with larger sites.
-- Hint: WHERE items.category = 'Vaccine'
--       CASE WHEN daily_capacity <= 100 THEN 'Small' ELSE 'Large' END
-- ---------------------------------------------------------------------


-- ---------------------------------------------------------------------
-- TODO 2.5  THE BIG QUESTION: WHY WERE CLIENTS TURNED AWAY?
--   Clients can be turned away because the site hit capacity, OR because
--   it ran out of something needed to vaccinate (vaccine, syringes, gloves).
--   a) How many turned-away clients were on days demand exceeded capacity?
--   b) How many were on days nitrile gloves (ITM05) were stocked out?
-- Hint for b): join daily_site_operations to daily_inventory on
--   op_date = inv_date AND site_id = site_id AND item_id = 'ITM05',
--   then filter WHERE closing_qty = 0.
-- ---------------------------------------------------------------------
