# **Module 1 Homework: Docker & SQL**

## **Question 1. Understanding docker first run**

*Run docker with the python:3.12.8 image in an interactive mode, use the entrypoint bash.* 

*What's the version of pip in the image?*

**Answer**:
In the terminal I run:
`docker run -it --entrypoint bash python:3.12.8`

Inside the container I check the pip version: `pip --version`

**`pip 24.3.1`** `from /usr/local/lib/python3.12/site-packages/pip (python 3.12)`

## **Question 2. Understanding Docker networking and docker-compose**

Given the following `docker-compose.yaml`, what is the **hostname** and **port** that **pgadmin** should use to connect to the **postgres database**?

```
services:
  db:
    container_name: postgres
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: 'postgres'
      POSTGRES_PASSWORD: 'postgres'
      POSTGRES_DB: 'ny_taxi'
    ports:
      - '5433:5432'
    volumes:
      - vol-pgdata:/var/lib/postgresql/data

  pgadmin:
    container_name: pgadmin
    image: dpage/pgadmin4:latest
    environment:
      PGADMIN_DEFAULT_EMAIL: "pgadmin@pgadmin.com"
      PGADMIN_DEFAULT_PASSWORD: "pgadmin"
    ports:
      - "8080:80"
    volumes:
      - vol-pgadmin_data:/var/lib/pgadmin  

volumes:
  vol-pgdata:
    name: vol-pgdata
  vol-pgadmin_data:
    name: vol-pgadmin_data
```

**Answer**: the hostname for the ppstgres database is its service name (**db**), while its port is the port specified for its container (**5432**)

**db:5432**


## Prepare Postgres

Run **Postgres** and load data as shown in the videos We'll use the **green taxi trips from October 2019**:

`wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz`

You will also need the dataset with zones:

`wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv`

Download this data and put it into Postgres.

You can use the code from the course. It's up to you whether you want to use Jupyter or a python script.

**Code created**: refer to `ingest_green_taxi.ipynb` (476,386 rows added in `green_taxi_data` table on postgres. The lookup `zones` was already uploaded in my postgres db)

## Question 3. Trip Segmentation Count

*During the period of **October 1st 2019 (inclusive)** and **November 1st 2019 (exclusive)**, how many trips, respectively, happened:*

- *Up to 1 mile*: **104,802** (this includes two negative mileages)
- *In between 1 (exclusive) and 3 miles (inclusive)*: I actually obtain **198,927**
- *In between 3 (exclusive) and 7 miles (inclusive)*: **109,603**
- *In between 7 (exclusive) and 10 miles (inclusive)*: **27,678**
- *Over 10 miles*: **35,189**

To answer the questions, I used the `trip_distance` field ("*the elapsed trip distance in miles reported by the taximeter*", https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_green.pdf) and the `lpep_dropoff_datetime` field ("*The date and time when the meter was disengaged*")

```
WITH CTE AS (
	SELECT
		CAST(lpep_dropoff_datetime AS DATE) AS dropoff_date,
		trip_distance, 
	CASE 
		WHEN trip_distance <= 1 THEN 'up to 1 mile'
		WHEN trip_distance > 1 AND trip_distance <= 3 THEN '1< miles <=3'
		WHEN trip_distance > 3 AND trip_distance <= 7 THEN '3< miles <=7'
		WHEN trip_distance > 7 AND trip_distance <= 10 THEN '7< miles <=10'
		ELSE 'Over 10 miles'
	END AS tot_miles
	FROM green_taxi_data
	WHERE 
		CAST(lpep_dropoff_datetime AS DATE) BETWEEN '2019-01-01' AND '2019-10-31'
		--AND trip_distance >= 0 --REMOVE negative values
)
SELECT 
	tot_miles, 
	COUNT(1) AS n_trips 
FROM CTE
GROUP BY tot_miles
;
```

**104,802; 198,924; 109,603; 27,678; 35,189**

