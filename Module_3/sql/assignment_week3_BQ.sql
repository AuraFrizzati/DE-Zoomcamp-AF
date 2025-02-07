-- exercise week3
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

-- Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. Now write a query to retrieve the PULocationID and DOLocationID on the same table. Why are the estimated number of Bytes different?

SELECT PULocationID
FROM `data-eng-week3-af.DW_demo.yellow_tripdata2024`; --122.12 MB

SELECT PULocationID,DOLocationID
FROM `data-eng-week3-af.DW_demo.yellow_tripdata2024`; --310.24 MB

-- How many records have a fare_amount of 0?

SELECT COUNT(1)
FROM `data-eng-week3-af.DW_demo.yellow_tripdata2024`
WHERE fare_amount = 0; --8333

-- What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID (Create a new table with this strategy)

CREATE OR REPLACE TABLE `data-eng-week3-af.DW_demo.yellow_tripdata2024_part_clust`
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
SELECT * FROM `data-eng-week3-af.DW_demo.yellow_tripdata2024`;

-- Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive)
--Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 5 and note the estimated bytes processed. What are these values? 

SELECT DISTINCT(VendorID)
FROM `data-eng-week3-af.DW_demo.yellow_tripdata2024`
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15'; --310.24 MB

SELECT DISTINCT(VendorID)
FROM `data-eng-week3-af.DW_demo.yellow_tripdata2024_part_clust`
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15'; --26.84 MB

-- No Points: Write a `SELECT count(*)` query FROM the materialized table you created. How many bytes does it estimate will be read? Why?

SELECT * FROM `data-eng-week3-af.DW_demo.yellow_tripdata2024`; --2.72 GB
SELECT (1) FROM `data-eng-week3-af.DW_demo.yellow_tripdata2024`; --0 B