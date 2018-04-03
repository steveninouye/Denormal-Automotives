-- 1. Create a new postgres user named `denormal_user`.
CREATE USER denormal_user;
-- 1. Create a new database named `denormal_cars` owned by `denormal_user`.
CREATE DATABASE denormal_cars
OWNER denormal_user;

-- 1. Run the provided `scripts/denormal_data.sql` script on the `denormal_cars` database.
\c denormal_cars;
\i scripts/denormal_data.sql;
-- 1. Inspect the table named `car_models` by running `\dS` and look at the data using some `SELECT` statements.
-- 1. In `denormal_cars.sql` Create a query to get a list of all `make_title` values in the `car_models` table. Without any duplicate rows, this should have 71 results.
SELECT DISTINCT ON
(make_title) make_title FROM car_models;
-- 1. In `denormal_cars.sql` Create a query to list all `model_title` values where the `make_code` is `'VOLKS'`. Without any duplicate rows, this should have 27 results.
SELECT DISTINCT ON
(model_title) model_title FROM car_models
WHERE make_code LIKE '%VOLKS%';
-- 1. In `denormal_cars.sql` Create a query to list all `make_code`, `model_code`, `model_title`, and year from `car_models` where the `make_code` is `'LAM'`,  Without any duplicate rows, this should have 136 rows.
SELECT DISTINCT ON
(make_code, model_code, model_title,year)make_code, model_code, model_title,year FROM car_models
WHERE make_code LIKE '%LAM%';
-- 1. In `denormal_cars.sql` Create a query to list all fields from all `car_models` in years between `2010` and `2015`. Without any duplicate rows, this should have 7884 rows.
SELECT DISTINCT *
FROM car_models
WHERE year BETWEEN 2010 AND 2015;