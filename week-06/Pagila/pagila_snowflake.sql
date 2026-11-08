DROP TABLE IF EXISTS fact_rental;
DROP TABLE IF EXISTS bridge_film_actor;
DROP TABLE IF EXISTS bridge_film_category;
DROP TABLE IF EXISTS dim_actor;
DROP TABLE IF EXISTS dim_category;
DROP TABLE IF EXISTS dim_film;
DROP TABLE IF EXISTS dim_language;
DROP TABLE IF EXISTS dim_customer;
DROP TABLE IF EXISTS dim_staff;
DROP TABLE IF EXISTS dim_store;
DROP TABLE IF EXISTS dim_address;
DROP TABLE IF EXISTS dim_city;
DROP TABLE IF EXISTS dim_country;
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
    country_id    INT NOT NULL UNIQUE,
    country_name  VARCHAR(50) NOT NULL
);

CREATE TABLE dim_city (
    city_key     SERIAL PRIMARY KEY,
    city_id      INT NOT NULL UNIQUE,
    city_name    VARCHAR(50) NOT NULL,
    country_key  INT NOT NULL REFERENCES dim_country (country_key)
);

CREATE TABLE dim_address (
    address_key  SERIAL PRIMARY KEY,
    address_id   INT NOT NULL UNIQUE,
    address      VARCHAR(50) NOT NULL,
    address2     VARCHAR(50),
    district     VARCHAR(50),
    postal_code  VARCHAR(10),
    phone        VARCHAR(20),
    city_key     INT NOT NULL REFERENCES dim_city (city_key)
);

CREATE TABLE dim_store (
    store_key           SERIAL PRIMARY KEY,
    store_id            INT NOT NULL UNIQUE,
    manager_first_name  VARCHAR(50),
    manager_last_name   VARCHAR(50),
    address_key         INT NOT NULL REFERENCES dim_address (address_key)
);

CREATE TABLE dim_staff (
    staff_key    SERIAL PRIMARY KEY,
    staff_id     INT NOT NULL UNIQUE,
    first_name   VARCHAR(50) NOT NULL,
    last_name    VARCHAR(50) NOT NULL,
    email        VARCHAR(50),
    username     VARCHAR(16) NOT NULL,
    active       BOOLEAN NOT NULL,
    address_key  INT NOT NULL REFERENCES dim_address (address_key)
);

CREATE TABLE dim_customer (
    customer_key  SERIAL PRIMARY KEY,
    customer_id   INT NOT NULL UNIQUE,
    first_name    VARCHAR(45) NOT NULL,
    last_name     VARCHAR(45) NOT NULL,
    email         VARCHAR(50),
    active        BOOLEAN NOT NULL,
    created_at    DATE NOT NULL,
    address_key   INT NOT NULL REFERENCES dim_address (address_key)
);

CREATE TABLE dim_language (
    language_key   SERIAL PRIMARY KEY,
    language_id    INT NOT NULL UNIQUE,
    language_name  VARCHAR(20) NOT NULL
);

CREATE TABLE dim_film (
    film_key            SERIAL PRIMARY KEY,
    film_id             INT NOT NULL UNIQUE,
    title               VARCHAR(255) NOT NULL,
    description         TEXT,
    release_year        SMALLINT,
    rental_duration     SMALLINT NOT NULL,
    rental_rate         NUMERIC(4,2) NOT NULL,
    length              SMALLINT,
    replacement_cost    NUMERIC(5,2) NOT NULL,
    rating              DOUBLE PRECISION,
    special_features    TEXT,
    revenue_projection  NUMERIC(5,2),
    language_key        INT NOT NULL REFERENCES dim_language (language_key)
);

CREATE TABLE dim_category (
    category_key   SERIAL PRIMARY KEY,
    category_id    INT NOT NULL UNIQUE,
    category_name  VARCHAR(25) NOT NULL
);

CREATE TABLE dim_actor (
    actor_key   SERIAL PRIMARY KEY,
    actor_id    INT NOT NULL UNIQUE,
    first_name  VARCHAR(45) NOT NULL,
    last_name   VARCHAR(45) NOT NULL
);

CREATE TABLE bridge_film_category (
    film_key      INT NOT NULL REFERENCES dim_film (film_key),
    category_key  INT NOT NULL REFERENCES dim_category (category_key),
    PRIMARY KEY (film_key, category_key)
);

CREATE TABLE bridge_film_actor (
    film_key   INT NOT NULL REFERENCES dim_film (film_key),
    actor_key  INT NOT NULL REFERENCES dim_actor (actor_key),
    PRIMARY KEY (film_key, actor_key)
);

CREATE TABLE fact_rental (
    rental_id          INT PRIMARY KEY,
    inventory_id       INT NOT NULL,
    rental_date_key    INT NOT NULL REFERENCES dim_date (date_key),
    return_date_key    INT REFERENCES dim_date (date_key),
    customer_key       INT NOT NULL REFERENCES dim_customer (customer_key),
    staff_key          INT NOT NULL REFERENCES dim_staff (staff_key),
    store_key          INT NOT NULL REFERENCES dim_store (store_key),
    film_key           INT NOT NULL REFERENCES dim_film (film_key),
    rental_fee         NUMERIC(4,2) NOT NULL,
    rental_days        INT CHECK (rental_days >= 0),
    late_days          INT CHECK (late_days >= 0),
    is_returned        BOOLEAN NOT NULL
);

CREATE INDEX idx_fact_rental_rental_date ON fact_rental (rental_date_key);
CREATE INDEX idx_fact_rental_return_date ON fact_rental (return_date_key);
CREATE INDEX idx_fact_rental_customer ON fact_rental (customer_key);
CREATE INDEX idx_fact_rental_staff ON fact_rental (staff_key);
CREATE INDEX idx_fact_rental_store ON fact_rental (store_key);
CREATE INDEX idx_fact_rental_film ON fact_rental (film_key);
CREATE INDEX idx_bridge_film_category_category ON bridge_film_category (category_key);
CREATE INDEX idx_bridge_film_actor_actor ON bridge_film_actor (actor_key);
