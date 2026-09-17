
-- WEEK 1: AGRIBUSINESS DATA ANALYTICS
-- Project: India Crop Production - State wise
-- Tool: MySQL


-- 1. DATABASE SETUP


create database agribusiness_week1;

use agribusiness_week1;



-- 2. RAW TABLE CREATION

-- The raw table is used to keep the original imported data
-- separate from the cleaned data.
--
-- Area and production are initially stored as numeric fields.
-- They are later changed to varchar so that blank values and
-- original formatting can be preserved during import and
-- data-quality checks.

create table crop_production_raw (
    state_name varchar(100),
    district_name varchar(100),
    crop_year int,
    season varchar(100),
    crop varchar(150),
    area decimal(15,2),
    production decimal(18,2)
);


-- Check the structure of the raw table

desc crop_production_raw;


-- During import, blank production values caused numeric
-- conversion issues. The raw table was therefore adjusted
-- to store area and production as text.
--
-- This allows the original values, including blanks and
-- non-standard decimal formatting such as .20, to be
-- preserved before cleaning.

alter table crop_production_raw
modify production varchar(50);

alter table crop_production_raw
modify area varchar(50);



-- 3. DATA IMPORT
-- The CSV file was imported using LOAD DATA INFILE.
-- The file is comma-separated, values are enclosed in
-- double quotes, and the file uses Windows-style line endings.

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/crop_production.csv'
into table crop_production_raw
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;


-- Verify the number of imported records

select count(*) as row_count
from crop_production_raw;


-- View a small sample of the imported data

select *
from crop_production_raw
limit 10;



-- 4. INITIAL DATA QUALITY CHECK
-- Check for missing values in each column.
-- Since area and production are stored as text in the raw
-- table, blank values are checked using ''.

select
    count(*) as total_rows,
    sum(state_name is null or state_name = '') as missing_state,
    sum(district_name is null or district_name = '') as missing_district,
    sum(crop_year is null or crop_year = '') as missing_crop_year,
    sum(season is null or season = '') as missing_season,
    sum(crop is null or crop = '') as missing_crop,
    sum(area is null or area = '') as missing_area,
    sum(production is null or production = '') as missing_production
from crop_production_raw;



-- 4.1 MISSING PRODUCTION INVESTIGATION 
-- Check how missing production values are distributed
-- across different seasons.

select
    season,
    count(*) as missing_production
from crop_production_raw
where production = ''
group by season
order by missing_production desc;


-- Check whether area is available when production is missing.

select
    count(*) as missing_production,
    sum(area = '') as missing_area_too,
    sum(area <> '') as area_available
from crop_production_raw
where production = '';


-- Check how missing production values are distributed
-- across different crop years.

select
    crop_year,
    count(*) as missing_production
from crop_production_raw
where production = ''
group by crop_year
order by crop_year;



-- 4.2 DUPLICATE RECORD CHECK
-- Compare the total number of rows with the number of
-- unique complete records.

select
    count(*) as total_rows,
    count(distinct state_name, district_name, crop_year,
          season, crop, area, production) as unique_rows
from crop_production_raw;



-- 4.3 TEXT FORMATTING CHECK
-- Check for leading or trailing whitespace in text fields.


-- Check crop names

select
    count(*) as rows_with_trailing_spaces
from crop_production_raw
where crop <> trim(crop);


-- Check state names

select
    count(*) as state_rows_with_whitespace
from crop_production_raw
where state_name <> trim(state_name);


-- Check district names

select
    count(*) as district_rows_with_whitespace
from crop_production_raw
where district_name <> trim(district_name);


-- Check season formatting.
-- Character length is checked to determine whether the
-- apparent padding is consistent across categories.

select
    season,
    char_length(season) as character_length,
    length(season) as byte_length,
    count(*) as row_count
from crop_production_raw
group by season, char_length(season), length(season)
order by season;


-- 4.4 NUMERIC DATA AND YEAR VALIDATION

-- Check the range and number of unique crop years.

select
    min(crop_year) as earliest_year,
    max(crop_year) as latest_year,
    count(distinct crop_year) as unique_years
from crop_production_raw;


-- Check area formatting.
-- The regular expression identifies values containing only
-- digits and an optional decimal part.
--
-- Values such as .20 are flagged by this pattern even though
-- they are valid decimal values. They are therefore treated
-- as non-standard formatting rather than invalid data.

select
    count(*) as total_area_values,
    sum(area = '') as blank_area,
    sum(area regexp '^[0-9]+(\.[0-9]+)?$') as numeric_area,
    sum(area <> '' and area not regexp '^[0-9]+(\.[0-9]+)?$') as non_standard_area
from crop_production_raw;


-- View examples of non-standard area formatting.

select distinct area
from crop_production_raw
where area <> ''
  and area not regexp '^[0-9]+(\.[0-9]+)?$';


-- Check production formatting.

select
    count(*) as total_production_values,
    sum(production = '') as blank_production,
    sum(production regexp '^[0-9]+(\.[0-9]+)?$') as numeric_production,
    sum(production <> '' and production not regexp '^[0-9]+(\.[0-9]+)?$') as non_standard_production
from crop_production_raw;


-- View examples of non-standard production formatting.

select distinct production
from crop_production_raw
where production <> ''
  and production not regexp '^[0-9]+(\.[0-9]+)?$'
limit 30;


-- 5. DATA CLEANING AND PRELIMINARY TRANSFORMATION
-- A separate cleaned table is created so that the raw
-- imported data remains unchanged for reference.
--
-- Cleaning actions:
-- 1. Remove leading and trailing spaces using TRIM().
-- 2. Convert blank area values to NULL.
-- 3. Convert blank production values to NULL.
-- 4. Convert area and production from text to decimal
--    through the data types of the cleaned table.
--
-- Missing production values are kept as NULL rather than
-- being changed to zero because a missing value does not
-- mean that production was zero.

create table crop_production_cleaned (
    state_name varchar(100),
    district_name varchar(100),
    crop_year int,
    season varchar(50),
    crop varchar(150),
    area decimal(15,2),
    production decimal(18,2)
);


-- Insert the cleaned and transformed data.

insert into crop_production_cleaned (
    state_name,
    district_name,
    crop_year,
    season,
    crop,
    area,
    production
)
select
    trim(state_name),
    trim(district_name),
    crop_year,
    trim(season),
    trim(crop),
    nullif(trim(area), ''),
    nullif(trim(production), '')
from crop_production_raw;


-- 6. POST-CLEANING VALIDATION
-- Compare the number of records in the raw and cleaned
-- tables to make sure that no rows were unintentionally
-- removed during cleaning.

select
    (select count(*) from crop_production_raw) as raw_rows,
    (select count(*) from crop_production_cleaned) as cleaned_rows;


-- Check the number of missing production values after
-- converting blanks to NULL.

select
    count(*) as missing_production
from crop_production_cleaned
where production is null;


-- Confirm that unnecessary whitespace has been removed.

select
    sum(state_name <> trim(state_name)) as state_whitespace,
    sum(season <> trim(season)) as season_whitespace,
    sum(crop <> trim(crop)) as crop_whitespace
from crop_production_cleaned;


-- Check that area and production have been converted
-- into numeric values.

select
    count(*) as total_rows,
    count(area) as area_values,
    count(production) as production_values
from crop_production_cleaned;


-- Check the number of distinct values in the cleaned data.

select
    count(distinct state_name) as states,
    count(distinct district_name) as districts,
    count(distinct crop_year) as years,
    count(distinct season) as seasons,
    count(distinct crop) as crops
from crop_production_cleaned;


-- 7. CLEANING SUMMARY
-- Final cleaning approach:
--
-- - Raw data was preserved in crop_production_raw.
-- - Blank production values were retained and converted
--   to NULL instead of being replaced with zero.
-- - Area values were retained because no area values were
--   missing.
-- - Leading and trailing whitespace was removed from text
--   fields using TRIM().
-- - Area and production were converted from text to decimal.
-- - Exact duplicate records were not removed because none
--   were identified.
-- - The cleaned table was validated against the raw table
--   to confirm that all records were retained.
--
-- This completes the SQL-based data acquisition, profiling,
-- cleaning, and preliminary transformation stage for Week 1.