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
CREATE TABLE vehicle_make AS
SELECT DISTINCT ON
(make_code,make_title) make_code,make_title FROM car_models;
ALTER TABLE vehicle_make ADD COLUMN make_id serial NOT NULL PRIMARY KEY;
CREATE TABLE vehicle_model AS
SELECT DISTINCT ON
(vehicle_make.make_id,model_code,model_title) vehicle_make.make_id,model_code,model_title FROM car_models 
JOIN vehicle_make on car_models.make_code=vehicle_make.make_code;
ALTER TABLE vehicle_model ADD COLUMN model_id serial NOT NULL PRIMARY KEY;
CREATE TABLE vehicle_date AS
SELECT DISTINCT ON
(vehicle_model.model_id,vehicle_make.make_id,year) vehicle_model.model_id,vehicle_make.make_id,year FROM car_models 
JOIN vehicle_make on car_models.make_code=vehicle_make.make_code
JOIN vehicle_model on car_models.model_code=vehicle_model.model_code;
ALTER TABLE vehicle_date ADD COLUMN date_id serial NOT NULL PRIMARY KEY;
-- 1. In `normal_cars.sql` Create a query to get a list of all `make_title` values in the `car_models` table. Without any duplicate rows, this should have 71 results.
SELECT DISTINCT ON
(make_title) make_title FROM vehicle_make;
-- 1. In `normal_cars.sql` Create a query to list all `model_title` values where the `make_code` is `'VOLKS'` Without any duplicate rows, this should have 27 results.
SELECT DISTINCT ON
(model_title) model_title FROM vehicle_model
JOIN vehicle_make ON vehicle_model.make_id = vehicle_make.make_id
WHERE vehicle_make.make_code LIKE '%VOLKS%';
-- 1. In `normal_cars.sql` Create a query to list all `make_code`, `model_code`, `model_title`, and year from `car_models` where the `make_code` is `'LAM'`. Without any duplicate rows, this should have 136 rows.
SELECT DISTINCT ON
(vehicle_make.make_code, vehicle_model.model_code, vehicle_model.model_title, year) vehicle_make.make_code, vehicle_model.model_code, vehicle_model.model_title, year FROM vehicle_date
JOIN vehicle_make ON vehicle_date.make_id = vehicle_make.make_id
JOIN vehicle_model ON vehicle_date.model_id = vehicle_model.model_id
WHERE vehicle_make.make_code LIKE '%LAM%';
-- 1. In `normal_cars.sql` Create a query to list all fields from all `car_models` in years between `2010` and `2015`. Without any duplicate rows, this should have 7884 rows.
SELECT DISTINCT *
FROM vehicle_date JOIN vehicle_make ON vehicle_date.make_id = vehicle_make.make_id JOIN vehicle_model ON vehicle_date.model_id = vehicle_model.model_id
WHERE year BETWEEN 2010 AND 2015;