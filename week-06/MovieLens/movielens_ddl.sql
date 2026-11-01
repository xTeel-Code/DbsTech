DROP TABLE IF EXISTS fact_ratings;
DROP TABLE IF EXISTS bridge_movie_genre;
DROP TABLE IF EXISTS dim_genre;
DROP TABLE IF EXISTS dim_movie;
DROP TABLE IF EXISTS dim_user;
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

CREATE TABLE dim_user (
    user_key    SERIAL PRIMARY KEY,
    user_id     INT NOT NULL UNIQUE,
    gender      CHAR(1) NOT NULL,
    age_group   VARCHAR(45) NOT NULL,
    occupation  VARCHAR(255) NOT NULL,
    zip_code    VARCHAR(255)
);

CREATE TABLE dim_movie (
    movie_key     SERIAL PRIMARY KEY,
    movie_id      INT NOT NULL UNIQUE,
    title         VARCHAR(255) NOT NULL,
    release_year  SMALLINT
);

CREATE TABLE dim_genre (
    genre_key  SERIAL PRIMARY KEY,
    genre_id   INT NOT NULL UNIQUE,
    name       VARCHAR(255) NOT NULL
);

CREATE TABLE bridge_movie_genre (
    movie_key  INT NOT NULL REFERENCES dim_movie (movie_key),
    genre_key  INT NOT NULL REFERENCES dim_genre (genre_key),
    PRIMARY KEY (movie_key, genre_key)
);

CREATE TABLE fact_ratings (
    rating_id  INT PRIMARY KEY,
    user_key   INT NOT NULL REFERENCES dim_user (user_key),
    movie_key  INT NOT NULL REFERENCES dim_movie (movie_key),
    date_id    INT NOT NULL REFERENCES dim_date (date_id),
    rated_at   TIMESTAMP NOT NULL,
    rating     SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5)
);

CREATE INDEX idx_fact_ratings_user ON fact_ratings (user_key);
CREATE INDEX idx_fact_ratings_movie ON fact_ratings (movie_key);
CREATE INDEX idx_fact_ratings_date ON fact_ratings (date_id);
