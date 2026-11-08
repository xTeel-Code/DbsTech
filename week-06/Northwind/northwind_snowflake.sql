DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_product;
DROP TABLE IF EXISTS dim_category;
DROP TABLE IF EXISTS dim_supplier;
DROP TABLE IF EXISTS dim_customer;
DROP TABLE IF EXISTS dim_city;
DROP TABLE IF EXISTS dim_country;
DROP TABLE IF EXISTS dim_employee;
DROP TABLE IF EXISTS dim_shipper;
DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_date (
    date_key     INT PRIMARY KEY,
    full_date    DATE NOT NULL UNIQUE,
    day          SMALLINT NOT NULL,
    day_of_week  SMALLINT NOT NULL,
    day_name     VARCHAR(10) NOT NULL,
    week         SMALLINT NOT NULL,
    month        SMALLINT NOT NULL,
    month_name   VARCHAR(10) NOT NULL,
    quarter      SMALLINT NOT NULL,
    year         SMALLINT NOT NULL,
    is_weekend   BOOLEAN NOT NULL
);

CREATE TABLE dim_country (
    country_key   SERIAL PRIMARY KEY,
    country_name  VARCHAR(15) NOT NULL UNIQUE
);

CREATE TABLE dim_city (
    city_key     SERIAL PRIMARY KEY,
    city_name    VARCHAR(20) NOT NULL,
    country_key  INT NOT NULL REFERENCES dim_country (country_key),
    UNIQUE (city_name, country_key)
);

CREATE TABLE dim_customer (
    customer_key   SERIAL PRIMARY KEY,
    customer_id    INT NOT NULL UNIQUE,
    customer_name  VARCHAR(50) NOT NULL,
    contact_name   VARCHAR(50),
    address        VARCHAR(50),
    postal_code    VARCHAR(10),
    city_key       INT NOT NULL REFERENCES dim_city (city_key)
);

CREATE TABLE dim_supplier (
    supplier_key   SERIAL PRIMARY KEY,
    supplier_id    INT NOT NULL UNIQUE,
    supplier_name  VARCHAR(50) NOT NULL,
    contact_name   VARCHAR(50),
    address        VARCHAR(50),
    postal_code    VARCHAR(10),
    phone          VARCHAR(15),
    city_key       INT NOT NULL REFERENCES dim_city (city_key)
);

CREATE TABLE dim_category (
    category_key   SERIAL PRIMARY KEY,
    category_id    INT NOT NULL UNIQUE,
    category_name  VARCHAR(25) NOT NULL,
    description    VARCHAR(255)
);

CREATE TABLE dim_product (
    product_key    SERIAL PRIMARY KEY,
    product_id     INT NOT NULL UNIQUE,
    product_name   VARCHAR(50) NOT NULL,
    unit           VARCHAR(25),
    list_price     NUMERIC(10,2),
    category_key   INT NOT NULL REFERENCES dim_category (category_key),
    supplier_key   INT NOT NULL REFERENCES dim_supplier (supplier_key)
);

CREATE TABLE dim_employee (
    employee_key  SERIAL PRIMARY KEY,
    employee_id   INT NOT NULL UNIQUE,
    first_name    VARCHAR(15) NOT NULL,
    last_name     VARCHAR(15) NOT NULL,
    birth_date    DATE
);

CREATE TABLE dim_shipper (
    shipper_key   SERIAL PRIMARY KEY,
    shipper_id    INT NOT NULL UNIQUE,
    shipper_name  VARCHAR(25) NOT NULL,
    phone         VARCHAR(15)
);

CREATE TABLE fact_sales (
    order_detail_id  INT PRIMARY KEY,
    order_id         INT NOT NULL,
    date_key         INT NOT NULL REFERENCES dim_date (date_key),
    customer_key     INT NOT NULL REFERENCES dim_customer (customer_key),
    employee_key     INT NOT NULL REFERENCES dim_employee (employee_key),
    product_key      INT NOT NULL REFERENCES dim_product (product_key),
    shipper_key      INT NOT NULL REFERENCES dim_shipper (shipper_key),
    quantity         INT NOT NULL CHECK (quantity > 0),
    unit_price       NUMERIC(10,2) NOT NULL,
    line_total       NUMERIC(12,2) NOT NULL
);

CREATE INDEX idx_fact_sales_date ON fact_sales (date_key);
CREATE INDEX idx_fact_sales_customer ON fact_sales (customer_key);
CREATE INDEX idx_fact_sales_employee ON fact_sales (employee_key);
CREATE INDEX idx_fact_sales_product ON fact_sales (product_key);
CREATE INDEX idx_fact_sales_shipper ON fact_sales (shipper_key);
