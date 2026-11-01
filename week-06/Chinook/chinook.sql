DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_location;
DROP TABLE IF EXISTS dim_track;
DROP TABLE IF EXISTS dim_employee;
DROP TABLE IF EXISTS dim_customer;
DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_date (
    date_id      INT PRIMARY KEY,
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

CREATE TABLE dim_customer (
    customer_key  SERIAL PRIMARY KEY,
    customer_id   INT NOT NULL UNIQUE,
    first_name    VARCHAR(40) NOT NULL,
    last_name     VARCHAR(20) NOT NULL,
    company       VARCHAR(80),
    city          VARCHAR(40),
    state         VARCHAR(40),
    country       VARCHAR(40),
    postal_code   VARCHAR(10),
    email         VARCHAR(60) NOT NULL
);

CREATE TABLE dim_employee (
    employee_key  SERIAL PRIMARY KEY,
    employee_id   INT NOT NULL UNIQUE,
    first_name    VARCHAR(20) NOT NULL,
    last_name     VARCHAR(20) NOT NULL,
    title         VARCHAR(30),
    manager_name  VARCHAR(41),
    hire_date     DATE,
    city          VARCHAR(40),
    country       VARCHAR(40)
);

CREATE TABLE dim_track (
    track_key     SERIAL PRIMARY KEY,
    track_id      INT NOT NULL UNIQUE,
    track_name    VARCHAR(200) NOT NULL,
    album_title   VARCHAR(160),
    artist_name   VARCHAR(120),
    genre_name    VARCHAR(120),
    media_type    VARCHAR(120),
    composer      VARCHAR(220),
    milliseconds  INT NOT NULL,
    bytes         INT
);

CREATE TABLE dim_location (
    location_key  SERIAL PRIMARY KEY,
    city          VARCHAR(40),
    state         VARCHAR(40),
    country       VARCHAR(40) NOT NULL,
    UNIQUE NULLS NOT DISTINCT (city, state, country)
);

CREATE TABLE fact_sales (
    invoice_line_id  INT PRIMARY KEY,
    invoice_id       INT NOT NULL,
    date_id          INT NOT NULL REFERENCES dim_date (date_id),
    customer_key     INT NOT NULL REFERENCES dim_customer (customer_key),
    employee_key     INT NOT NULL REFERENCES dim_employee (employee_key),
    track_key        INT NOT NULL REFERENCES dim_track (track_key),
    location_key     INT NOT NULL REFERENCES dim_location (location_key),
    unit_price       NUMERIC(10,2) NOT NULL,
    quantity         INT NOT NULL CHECK (quantity > 0),
    line_total       NUMERIC(10,2) NOT NULL
);

CREATE INDEX idx_fact_sales_date ON fact_sales (date_id);
CREATE INDEX idx_fact_sales_customer ON fact_sales (customer_key);
CREATE INDEX idx_fact_sales_employee ON fact_sales (employee_key);
CREATE INDEX idx_fact_sales_track ON fact_sales (track_key);
CREATE INDEX idx_fact_sales_location ON fact_sales (location_key);
