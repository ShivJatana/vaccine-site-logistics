-- =====================================================================
-- STEP 0: CREATE THE DATABASE (run once)
--
-- 1. DB Browser for SQLite -> New Database -> save as vaccine_logistics.db
--    (close the "Edit table definition" pop-up if it appears)
-- 2. Execute SQL tab -> paste this whole file -> Run (▶) -> Write Changes
-- 3. File -> Import -> Table from CSV file... -> select ALL 8 files in data/
--    - Tick "Column names in first line"
--    - When asked whether to import into the existing table, click Yes
-- 4. Write Changes (Ctrl+S). Done!
--
-- Creating the tables first (instead of letting the import guess) makes
-- sure numbers are stored as numbers, so math and comparisons work.
-- =====================================================================

CREATE TABLE suppliers (
    supplier_id              TEXT PRIMARY KEY,
    supplier_name            TEXT,
    promised_lead_time_days  INTEGER
);

CREATE TABLE items (
    item_id          TEXT PRIMARY KEY,
    item_name        TEXT,
    category         TEXT,
    unit             TEXT,
    supplier_id      TEXT REFERENCES suppliers(supplier_id),
    shelf_life_days  INTEGER
);

CREATE TABLE sites (
    site_id         TEXT PRIMARY KEY,
    site_name       TEXT,
    region          TEXT,
    site_type       TEXT,
    daily_capacity  INTEGER,
    open_date       TEXT,
    close_date      TEXT
);

CREATE TABLE responders (
    responder_id  TEXT PRIMARY KEY,
    role          TEXT
);

CREATE TABLE daily_site_operations (
    op_date              TEXT,
    site_id              TEXT REFERENCES sites(site_id),
    clients_requesting   INTEGER,
    doses_administered   INTEGER,
    clients_turned_away  INTEGER,
    responders_on_shift  INTEGER
);

CREATE TABLE daily_inventory (
    inv_date      TEXT,
    site_id       TEXT REFERENCES sites(site_id),
    item_id       TEXT REFERENCES items(item_id),
    opening_qty   INTEGER,
    received_qty  INTEGER,
    used_qty      INTEGER,
    wasted_qty    INTEGER,
    closing_qty   INTEGER
);

CREATE TABLE deliveries (
    delivery_id     TEXT PRIMARY KEY,
    site_id         TEXT REFERENCES sites(site_id),
    item_id         TEXT REFERENCES items(item_id),
    supplier_id     TEXT REFERENCES suppliers(supplier_id),
    order_date      TEXT,
    expected_date   TEXT,
    delivered_date  TEXT,
    qty_ordered     INTEGER,
    qty_received    INTEGER
);

CREATE TABLE responder_shifts (
    shift_date    TEXT,
    site_id       TEXT REFERENCES sites(site_id),
    responder_id  TEXT REFERENCES responders(responder_id),
    hours         INTEGER
);
