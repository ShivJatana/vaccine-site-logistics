# Dashboard brief: one page in Power BI

**Audience:** a regional operations manager with 30 seconds to spare.
**Goal:** show the turned-away problem, its cause, and where to act.

*This is the design for a Power BI version of the dashboard. The results it will show are already in the main README.*

## 1. Load the data
1. Power BI Desktop → **Get data → Text/CSV**. Load every file in `data/`.
2. **Model view:** check the relationships Power BI creates, and add any missing ones:
   - `sites[site_id]` → `daily_site_operations`, `daily_inventory`, `deliveries`, `responder_shifts`
   - `items[item_id]` → `daily_inventory`, `deliveries`
   - `suppliers[supplier_id]` → `items`
   - Leave the `suppliers` → `deliveries` link inactive. Suppliers already reach deliveries through `items`, and a second path would create a loop.
3. Make sure the date columns are set to the **Date** type.

## 2. Measures to create (DAX)
Create these with **New measure**. Each one matches a query in `sql/02_kpis.sql`.

| Measure | Logic |
|---|---|
| Doses Given | sum of `doses_administered` |
| Turned Away % | turned away ÷ clients requesting |
| On-Time Delivery % | deliveries where delivered ≤ expected ÷ all deliveries |
| Stock-out Days | count of `daily_inventory` rows where `closing_qty` = 0 |
| Vaccine Wastage % | wasted ÷ (used + wasted), vaccine items only |

*On-Time %:* add a calculated column `OnTime = IF(deliveries[delivered_date] <= deliveries[expected_date], 1, 0)`, then average it.

## 3. Layout (one page)

```
┌──────────────────────────────────────────────────────────────┐
│ Title: Vaccine Site Logistics, Apr–Aug 2021 (sample data)    │
├────────────┬────────────┬─────────────┬──────────────────────┤
│ Doses Given│ Turned Away│ On-Time Del.│ Vaccine Wastage %    │  ← 4 KPI cards
├────────────┴────────────┴─────────────┼──────────────────────┤
│ Line chart: clients requesting vs     │ Bar chart: on-time % │
│ doses given, by week                  │ by supplier          │
├───────────────────────────────────────┼──────────────────────┤
│ Bar chart: stock-out days by item     │ Map or bar: doses by │
│ (colour by supplier)                  │ region               │
└───────────────────────────────────────┴──────────────────────┘
  Slicers: region · site type · month
```

## 4. Design rules
- Give every chart a title that states the takeaway, e.g. *"NorthPath was late on 4 in 10 deliveries"*, not *"On-time % by supplier"*.
- Keep it to 2–3 colours, with red reserved for the problem.
- Once it's built, save a screenshot as `dashboard/dashboard.png` and add it to the README, along with the `.pbix` file.
