DROP TABLE IF EXISTS distribution_geo_year_regione;
DROP TABLE IF EXISTS distribution_geo_year_provincia;
DROP TABLE IF EXISTS distribution_geo_year_comune;
DROP TABLE IF EXISTS distribution_geo_year_prefisso;

DROP TABLE IF EXISTS distribution_geo_month_regione;
DROP TABLE IF EXISTS distribution_geo_month_provincia;
DROP TABLE IF EXISTS distribution_geo_month_comune;
DROP TABLE IF EXISTS distribution_geo_month_prefisso;

DROP TABLE IF EXISTS distribution_geo_week_regione;
DROP TABLE IF EXISTS distribution_geo_week_provincia;
DROP TABLE IF EXISTS distribution_geo_week_comune;
DROP TABLE IF EXISTS distribution_geo_week_prefisso;

DROP TABLE IF EXISTS distribution_geo_day_regione;
DROP TABLE IF EXISTS distribution_geo_day_provincia;
DROP TABLE IF EXISTS distribution_geo_day_comune;
DROP TABLE IF EXISTS distribution_geo_day_prefisso;

eREATE TABLE distribution_geo_year_regione AS
SELECT
       Date_format(From_unixtime(timestamp_in), "%Y") AS period,
       qname,
       qdescr,
       prefisso,
       comune,
       provincia,
       regione,
       Count(id) AS total
FROM
       report_queue_callers
WHERE
       regione IS NOT NULL
GROUP BY
       period,
       qname,
       regione
ORDER BY
       period,
       qname,
       comune,
       provincia,
       regione;

CREATE TABLE distribution_geo_month_regione AS
SELECT
       Date_format(From_unixtime(timestamp_in), "%Y-%m") AS period,
       qname,
       qdescr,
       prefisso,
       comune,
       provincia,
       regione,
       Count(id) AS total
FROM
       report_queue_callers
WHERE
       regione IS NOT NULL
GROUP BY
       period,
       qname,
       regione
ORDER BY
       period,
       qname,
       comune,
       provincia,
       regione;

CREATE TABLE distribution_geo_week_regione AS
SELECT
       Date_format(From_unixtime(timestamp_in), "%x-W%v") AS period,
       qname,
       qdescr,
       prefisso,
       comune,
       provincia,
       regione,
       Count(id) AS total
FROM
       report_queue_callers
WHERE
       regione IS NOT NULL
GROUP BY
       period,
       qname,
       regione
ORDER BY
       period,
       qname,
       comune,
       provincia,
       regione;

CREATE TABLE distribution_geo_day_regione AS
SELECT
       Date_format(From_unixtime(timestamp_in), "%Y-%m-%d") AS period,
       qname,
       qdescr,
       prefisso,
       comune,
       provincia,
       regione,
       Count(id) AS total
FROM
       report_queue_callers
WHERE
       regione IS NOT NULL
GROUP BY
       period,
       qname,
       regione
ORDER BY
       period,
       qname,
       comune,
       provincia,
       regione;
