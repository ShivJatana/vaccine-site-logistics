# 💉 Vaccine Site Logistics Analysis

**Why were clients turned away from mobile COVID-19 vaccination clinics, and how could better inventory planning have prevented it?**

> ⚠️ **Sample data.** Every site, supplier, quantity and date in this project is **synthetic**, generated to resemble the kind of multi-site clinic logistics I supported with the Canadian Red Cross (2020–2022). It contains no real Red Cross, client or supplier data.

---

## The scenario

A network of **32 mobile and pop-up vaccination sites** across York, Peel, Toronto, Durham and Halton ran from April to August 2021. Each site:

- received vaccine, syringes, swabs and PPE from **4 suppliers**,
- reordered **once a week (Mondays)** based on the previous week's use,
- was staffed from a pool of **13 responders**.

**About 1 in 8 clients who came for a vaccine were turned away.** Leadership wants to know why, and what to change.

## Business questions

1. Where and when was demand highest? Did sites have enough capacity?
2. Which suppliers delivered late or short, and did that cause stock-outs?
3. Which items ran out most often, and did a stock-out stop vaccinations?
4. How much vaccine was wasted, and at which kinds of sites?
5. What reorder points and safety stock would have prevented the stock-outs?

---

## The data

The data is in `data/` as 8 CSV files. You'll load them into a SQLite database for the SQL work, and straight into Power BI for the dashboard.

| Table | Rows | One row = |
|---|---|---|
| `sites` | 32 | a clinic site: region, type, daily capacity, open/close dates |
| `items` | 9 | a stocked item: vaccine, PPE or medical supply, plus its supplier |
| `suppliers` | 4 | a supplier and its promised lead time (days) |
| `responders` | 13 | a responder and their role |
| `daily_site_operations` | 1,921 | one site on one day: clients requesting, doses given, clients turned away |
| `daily_inventory` | 17,289 | one item at one site on one day: opening, received, used, wasted, closing |
| `deliveries` | 2,665 | one order: order date, expected date, delivered date, qty ordered vs received |
| `responder_shifts` | 8,481 | one responder working one shift at one site |

**Key relationships:** `site_id` links sites to operations, inventory, deliveries and shifts. `item_id` links items to inventory and deliveries. `supplier_id` links suppliers to items and deliveries.

---

## How to work through this project

### Setup (20 min)
1. Download this repo: green **Code** button → **Download ZIP**, then unzip it.
2. Install **[DB Browser for SQLite](https://sqlitebrowser.org/)** (free).
3. Build the database by following the steps at the top of **`sql/00_create_database.sql`**.
4. Click the **Browse Data** tab and look at each table.
5. Open the **Execute SQL** tab. You'll paste queries from the `sql/` folder there.

### Part 1: Explore (`sql/01_explore.sql`)
Run the 3 worked examples, read how each one works, then write **TODO 1.1 to 1.4** yourself.

### Part 2: KPIs (`sql/02_kpis.sql`)
Calculate supplier on-time %, fill rate, stock-out days, vaccine wastage and the causes of turned-away clients. **TODO 2.5 is the most important query in the project.**

### Part 3: Fix the problem (`sql/03_reorder_points.sql`)
Calculate lead times, then safety stock and reorder points for one site.

### Part 4: Dashboard (`dashboard/DASHBOARD_BRIEF.md`)
Build a one-page Power BI dashboard from the CSVs. Save a screenshot as `dashboard/dashboard.png`.

### Part 5: Write it up (`findings/FINDINGS.md`)
Fill in the template: 3–5 findings, each with a number and a recommendation. Then copy your top findings into the **Results** section at the bottom of this README.

---

## ✅ Check your work

If your queries match these numbers, you're on track.

| Check | Expected |
|---|---|
| Date range of operations | 2021-04-08 to 2021-08-26 |
| Total doses administered | 267,861 |
| Total clients requesting | 303,760 |
| Clients turned away | 11.8% |
| Region with the most doses | Peel (75,702) |
| Avg clients requesting: Saturday vs weekday | ~205 vs ~149 |
| Lowest supplier on-time % | NorthPath Medical, ~59% |
| Items with the most stock-out days | Surgical masks (184), Nitrile gloves (151) |
| Vaccine wastage: small vs large sites | ~5.7% vs ~1.5% |

---

## Tools
SQL (SQLite) · Excel · Power BI

## Results
*To be completed: add your dashboard screenshot and top 3 findings here.*

<!-- ![Dashboard](dashboard/dashboard.png) -->
