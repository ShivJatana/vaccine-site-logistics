# Dashboard brief: one page in Power BI

**Audience:** a regional operations manager with 30 seconds to spare.
**Goal:** show the turned-away problem, its cause, and where to act.

## 1. Load the data
1. Power BI Desktop → **Get data → Text/CSV**. Load every file in `data/`.
2. **Model view:** check the relationships Power BI creates, and add any missing ones:
   - `sites[site_id]` → `daily_site_operations`, `daily_inventory`, `deliveries`, `responder_shifts`
   - `items[item_id]` → `daily_inventory`, `deliveries`
   - `suppliers[supplier_id]` → `items`, `deliveries`
3. Make sure the date columns are set to the **Date** type.

## 2. Measures to create (DAX)
Write these yourself in **New measure**. The logic matches your SQL from Part 2.

| Measure | Logic |
|---|---|
| Doses Given | sum of `doses_administered` |
| Turned Away % | turned away ÷ clients requesting |
| On-Time Delivery % | deliveries where delivered ≤ expected ÷ all deliveries |
| Stock-out Days | count of `daily_inventory` rows where `closing_qty` = 0 |
| Vaccine Wastage % | wasted ÷ (used + wasted), vaccine items only |

*Hint for On-Time %:* add a calculated column `OnTime = IF(deliveries[delivered_date] <= deliveries[expected_date], 1, 0)`, then average it.

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

## 4. Finish
- Give every chart a title that states the takeaway, e.g. *"NorthPath was late on 4 in 10 deliveries"*, not *"On-time % by supplier"*.
- Keep it to 2–3 colours, with red reserved for the problem.
- Export a screenshot → `dashboard/dashboard.png`. Optionally, save the `.pbix` file in this folder too.
