# GlareDB playground

This is a place to tinker with query federation OSS software GlareDB

## Dev Container support

> This is a work-in-progress. Currently not working on aarch64 (Mac M3) [Pull request](https://github.com/sharkymark/glaredb-hw/pull/1) to build an aarch64 distro of the `pip` package. Otherwise, `pip install glaredb` requires Rust because pypi doesn't have a prebuilt glaredb library for that arch/distro/etc combo so it tries to build from source.

## Sample Internet queries

### NYC real estate transactions from 2022

```sql
SELECT *
FROM read_parquet('https://github.com/GlareDB/tutorial_data/raw/main/quickstart_data/nyc_sales-2022_01.parquet');
```

### Query data from a local file

> Manually [download the file](https://github.com/GlareDB/tutorial_data/raw/main/quickstart_data/nyc_sales-2022_02.parquet) and put in the `./data/input` directory

```sql
-- Relative path to the same directory from which you started the GlareDB CLI
SELECT * FROM read_parquet('./data/input/nyc_sales-2022_02.parquet');
```

### Postgres customer data

```sql
SELECT * FROM read_postgres(
'postgresql://demo:demo@pg.demo.glaredb.com:5432/postgres', --connection
'public', --schema name
'customer' --table name
);
```

### JOIN Postgres data with remote file to get number of sales per NYC borough

```sql
SELECT
    COUNT(sales.sale_date),
    lookup.borough_name
FROM
     read_parquet('https://github.com/GlareDB/tutorial_data/raw/main/quickstart_data/nyc_sales-2022_01.parquet') sales
JOIN
    read_postgres(
        'postgresql://demo:demo@pg.demo.glaredb.com:5432/postgres',
        'public',
        'borough_lookup'
    ) lookup
ON sales.borough = lookup.borough_id
GROUP BY lookup.borough_name;
```

### JOIN Postgres data with local file to get number of sales per NYC borough

```sql
SELECT
    COUNT(sales.sale_date),
    lookup.borough_name
FROM
     read_parquet('./data/input/nyc_sales-2022_02.parquet') sales
JOIN
    read_postgres(
        'postgresql://demo:demo@pg.demo.glaredb.com:5432/postgres',
        'public',
        'borough_lookup'
    ) lookup
ON sales.borough = lookup.borough_id
GROUP BY lookup.borough_name;
```

### Export the JOIN to a local table in your GlareDB deployment

```sql
CREATE TABLE sales_aggregate_by_borough AS
    SELECT
        COUNT(sales.sale_date),
        lookup.borough_name
    FROM
        read_parquet('https://github.com/GlareDB/tutorial_data/raw/main/quickstart_data/nyc_sales-2022_01.parquet') sales
    JOIN
        read_postgres(
            'postgresql://demo:demo@pg.demo.glaredb.com:5432/postgres',
            'public',
            'borough_lookup'
        ) lookup
    ON sales.borough = lookup.borough_id
    GROUP BY lookup.borough_name;

SELECT *
FROM sales_aggregate_by_borough;
```

### Export the JOIN to a Parquet file

```sql
COPY (
    SELECT
        COUNT(sales.sale_date),
        lookup.borough_name
    FROM
        read_parquet('https://github.com/GlareDB/tutorial_data/raw/main/quickstart_data/nyc_sales-2022_01.parquet') sales
    JOIN
        read_postgres(
            'postgresql://demo:demo@pg.demo.glaredb.com:5432/postgres',
            'public',
            'borough_lookup'
        ) lookup
    ON sales.borough = lookup.borough_id
    GROUP BY lookup.borough_name
) TO './data/input/sales_aggregate_by_borough.parquet';

SELECT *
FROM './data/input/sales_aggregate_by_borough.parquet';
```


## Resources

[Python Mac versions](https://www.python.org/downloads/macos/)

[dev container spec](https://containers.dev/implementors/json_reference/)

[GlareDB docs](https://docs.glaredb.com/)

[GlareDB website](https://glaredb.com/)

[Rust releases](https://doc.rust-lang.org/beta/releases.html)

## License

This project is licensed under the [MIT License](LICENSE)

## Contributing

### Disclaimer: Unmaintained and Untested Code

Please note that this program is not actively maintained or tested. While it may work as intended, it's possible that it will break or behave unexpectedly due to changes in dependencies, environments, or other factors.

Use this program at your own risk, and be aware that:
1. Bugs may not be fixed
1. Compatibility issues may arise
1. Security vulnerabilities may exist

If you encounter any issues or have concerns, feel free to open an issue or submit a pull request.