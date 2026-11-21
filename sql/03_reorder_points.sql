-- =====================================================================
-- PART 3: FIX THE PROBLEM — REORDER POINTS
-- The sites reordered once a week (Mondays) based on last week's use.
-- Your job: recommend a reorder point and safety stock per item.
--
--   Reorder point = (average daily use x lead time in days) + safety stock
--   Safety stock  = (max daily use x max lead time) - (avg daily use x avg lead time)
--
-- This is the classic "max-min" safety stock formula. It's simple to explain
-- in an interview, which matters more here than statistical precision.
-- =====================================================================


-- ---------------------------------------------------------------------
-- WORKED EXAMPLE: Average and maximum daily use per item, per site
-- ---------------------------------------------------------------------
SELECT site_id,
       item_id,
       ROUND(AVG(used_qty), 1) AS avg_daily_use,
       MAX(used_qty)           AS max_daily_use
FROM daily_inventory
GROUP BY site_id, item_id;


-- ---------------------------------------------------------------------
-- TODO 3.1  ACTUAL LEAD TIMES PER SUPPLIER
--   Average and maximum actual lead time (order_date -> delivered_date).
-- Hint: julianday(delivered_date) - julianday(order_date)
-- ---------------------------------------------------------------------


-- ---------------------------------------------------------------------
-- TODO 3.2  REORDER POINT TABLE
--   Combine the worked example with 3.1 (join items to get supplier_id)
--   and calculate safety_stock and reorder_point for each item at ONE
--   site of your choice (e.g. the busiest site from TODO 1.2).
-- Hint: Use WITH ... AS (...) to build each piece as a mini-table first:
--   WITH usage AS (...), lead AS (...)
--   SELECT ... FROM usage JOIN items ... JOIN lead ...
-- ---------------------------------------------------------------------


-- ---------------------------------------------------------------------
-- TODO 3.3  WRITE IT UP (in findings/FINDINGS.md, not SQL)
--   For nitrile gloves at your chosen site: what reorder point would you
--   set, and how much higher is it than a "last week + 10%" order?
--   What would you say to NorthPath Medical, or would you add a backup supplier?
-- ---------------------------------------------------------------------
