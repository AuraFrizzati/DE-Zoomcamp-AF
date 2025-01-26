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

