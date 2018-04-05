-- 1. Create a new postgres user named `normal_user`.
CREATE USER normal_user;
-- 1. Create a new database named `normal_cars` owned by `normal_user`.
CREATE DATABASE normal_cars
OWNER normal_user;
-- 1. Run the provided `scripts/denormal_data.sql` script on the `normal_cars` database.
\c normal_cars;
\i scripts/denormal_data.sql;
-- 1. Whiteboard your solution to normalizing the `denormal_cars` schema.
-- 1. [bonus] Generate a diagram (somehow) in .png (or other) format, that of your normalized cars schema. (save and commit to this repo).
-- 1. In `normal_cars.sql` Create a query to generate the tables needed to accomplish your normalized schema, including any primary and foreign key constraints. Logical renaming of columns is allowed.
--   make_code character varying(125) NOT NULL,
--   make_title character varying(125) NOT NULL,
--   model_code character varying(125) NOT NULL,
--   model_title character varying(125) NOT NULL,
--   year integer NOT NULL
-- 1. Using the resources that you now possess, In `normal_cars.sql` Create queries to insert **all** of the data that was in the `car_models` table, into the new normalized tables of the `normal_cars` database.
CREATE TABLE vehicle_make (
    make_id serial NOT NULL PRIMARY KEY,
    make_code varchar(125) NOT NULL,
    make_title varchar(125) NOT NULL
);

CREATE TABLE vehicle_model (
    model_id serial NOT NULL PRIMARY KEY,
    model_code varchar(125) NOT NULL,
    model_title varchar(125) NOT NULL,
    model_make_id integer NOT NULL REFERENCES vehicle_make(make_id)
);

CREATE TABLE vehicle_year (
    date_id serial NOT NULL PRIMARY KEY,
    year NUMERIC(4,0) NOT NULL,
    year_model_id integer NOT NULL REFERENCES vehicle_model(model_id)
);

INSERT INTO vehicle_make(make_code,make_title)
SELECT DISTINCT make_code,make_title FROM car_models;

INSERT INTO vehicle_model(model_code,model_title, model_make_id)
SELECT DISTINCT model_code,model_title,vehicle_make.make_id FROM car_models
JOIN vehicle_make USING (make_code); 

INSERT INTO vehicle_year(year,year_model_id)
SELECT DISTINCT year,vehicle_model.model_id FROM car_models
JOIN vehicle_model USING (model_code);


-- 1. In `normal_cars.sql` Create a query to get a list of all `make_title` values in the `car_models` table. Without any duplicate rows, this should have 71 results.
SELECT DISTINCT make_title FROM vehicle_make;


-- 1. In `normal_cars.sql` Create a query to list all `model_title` values where the `make_code` is `'VOLKS'` Without any duplicate rows, this should have 27 results.

-- 1. In `normal_cars.sql` Create a query to list all `make_code`, `model_code`, `model_title`, and year from `car_models` where the `make_code` is `'LAM'`. Without any duplicate rows, this should have 136 rows.

-- 1. In `normal_cars.sql` Create a query to list all fields from all `car_models` in years between `2010` and `2015`. Without any duplicate rows, this should have 7884 rows.
