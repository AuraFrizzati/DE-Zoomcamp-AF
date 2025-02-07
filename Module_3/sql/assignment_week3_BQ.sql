-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `data-eng-week3-af.DW_demo.external_yellow_tripdata2024`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://data-eng-week3-af-terra-bucket-v2/yellow_tripdata_2024-*.parquet']
);

-- Create a non partitioned table from external table
CREATE OR REPLACE TABLE `data-eng-week3-af.DW_demo.yellow_tripdata2024` AS
SELECT * FROM `data-eng-week3-af.DW_demo.external_yellow_tripdata2024`;

-- Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
-- external table
SELECT COUNT(1)
FROM
(SELECT DISTINCT(PULocationID)
FROM `data-eng-week3-af.DW_demo.external_yellow_tripdata2024`) AS t
; -- COUNT= 262, 0 MB

-- materialised table
SELECT COUNT(1)
FROM
(SELECT DISTINCT(PULocationID)
FROM `data-eng-week3-af.DW_demo.yellow_tripdata2024`) AS t
;-- COUNT= 262, 155.12 MB
