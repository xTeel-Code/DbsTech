-- 1. Vytvorenie databázy
CREATE DATABASE retail;

-- Pripojte sa k databáze retail (v psql: \c retail) a ďalej pracujte v nej.

-- Dátumy v CSV sú vo formáte D.M.YYYY H:MI (napr. 1.12.2010 8:26),
-- preto nastavíme poradie deň-mesiac-rok, aby sa import načítal správne.
-- (Po tomto príkaze sa v pgAdmin znovu pripojte k databáze.)
ALTER DATABASE retail SET datestyle TO 'ISO, DMY';

-- 2. Vytvorenie tabuľky retail_sales
CREATE TABLE retail_sales (
    invoice_no   VARCHAR(20),
    stock_code   VARCHAR(50),
    description  TEXT,
    quantity     INTEGER,
    invoice_date TIMESTAMP,
    unit_price   NUMERIC(10,2),
    customer_id  INTEGER,
    country      VARCHAR(100)
);

-- 4. Import: pgAdmin -> retail_sales -> Import/Export Data
--    Format: csv, Header: ON, Delimiter: ;, Encoding: UTF8

-- 5. Overenie importu
SELECT *
FROM retail_sales;

SELECT COUNT(*) FROM retail_sales;  -- očakávané: 92 822 riadkov
