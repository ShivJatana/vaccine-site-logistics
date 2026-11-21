# Findings & recommendations

*Analysis of 32 mobile vaccination sites, April–August 2021 (synthetic sample data). Queries: [`sql/`](../sql).*

## Summary
**35,899 clients (11.8%) were turned away.** About a third hit a site at full capacity, mostly on Saturdays and during the June–July surge. Two-thirds were turned away because a site ran out of supplies, and almost all of those were on days a site had **run out of nitrile gloves**. Vaccine itself almost never ran out. The single most important fix is to stop gloves from running out: set reorder points instead of weekly orders, and add a backup glove supplier.

## Finding 1: Supplies, not vaccine, drove most turn-aways
**Evidence:** Of 35,899 clients turned away, 12,675 (35%) were due to capacity and 23,224 (65%) to supplies. **20,338 of the supply turn-aways (88%) were on glove stock-out days.** Vaccine ran out on only 17 site-days in total. *(Query 2.5)*
**Recommendation:** Treat gloves, syringes and vaccine as "critical to vaccinate" items, with their own daily stock check and the highest replenishment priority.

## Finding 2: One supplier was late 4 times in 10
**Evidence:** NorthPath Medical, which supplied gloves and surgical masks, delivered on time only **58.7%** of the time, versus 91–93% for the other three suppliers. When late, it averaged 3.3 days late. Its actual lead time averaged 4.4 days against a promised 3, and peaked at 8. Fill rates were about 98% for every supplier, so the issue was timing, not short shipments. *(Queries 2.1, 2.2, 3.1)*
**Recommendation:** Put NorthPath on a weekly scorecard with an on-time target of 90% or better, and qualify a second glove and mask supplier. Until on-time delivery improves, plan glove stock on the 8-day worst case, not the promised 3 days.

## Finding 3: NorthPath items stocked out the most
**Evidence:** Surgical masks were out on **184** site-days and nitrile gloves on **151**, both supplied by NorthPath. Sharps containers (138) were next. N95s and gowns were out on 65–67 days. *(Query 2.3)*
**Recommendation:** Masks and gowns don't stop vaccinations, but they put responder safety at risk. Keep a small regional buffer of PPE that sites can draw on the same day.

## Finding 4: Small sites waste nearly 4 times as much vaccine
**Evidence:** Sites with capacity of 100 or fewer a day wasted **5.7%** of their vaccine, versus **1.5%** at larger sites. Lower client volume makes it harder to use every dose in an opened vial. *(Query 2.4)*
**Recommendation:** At small sites, book appointments in batches matched to the doses in a vial. Stop opening new vials in the last hour unless enough clients are waiting to use the whole vial.

## Finding 5: Weekly ordering can't keep up with demand peaks
**Evidence:** Saturday demand averaged **205 clients** versus **149** on weekdays (+37%). During the surge (June 14 to July 17), turn-aways rose from 7.3% to **18.6%**. At Malton, the busiest site, weekly glove orders averaged about 1,500 pairs, and the site still ran out of gloves on **9 of its 79 days**. The max-min method gives a **reorder point of about 2,560 pairs**, with about 1,515 pairs of safety stock. *(Queries 1.4, 1.6, 3.2, 3.3)*
**Recommendation:** Replace the Monday-only order with a daily check against each item's reorder point. Add Saturday and surge staffing at the highest-demand sites to cut the capacity turn-aways.

## What I'd do differently with real data
- Capture **demand by appointment vs walk-in**, to separate unmet booked demand from walk-in overflow.
- Track **vial-level opening times**, to measure wastage precisely rather than estimating it per day.
- Build **supplier scorecards** from delivery data automatically, and review them weekly with procurement.
