DROP TABLE IF EXISTS distribution_geo_year; 

DROP TABLE IF EXISTS distribution_geo_month; 

DROP TABLE IF EXISTS distribution_geo_week; 

DROP TABLE IF EXISTS distribution_geo_day; 

CREATE TABLE distribution_geo_year AS 
  SELECT Date_format(From_unixtime(timestamp_in), "%Y") AS period, 
         qname, 
         qdescr, 
         prefisso, 
         comune, 
         provincia, 
         regione, 
         Count(id)                                      AS total 
  FROM   report_queue_callers 
  WHERE  regione IS NOT NULL 
  GROUP  BY period, 
            qname, 
            regione 
  ORDER  BY period, 
            qname, 
            comune, 
            provincia, 
            regione; 

CREATE TABLE distribution_geo_month AS 
  SELECT Date_format(From_unixtime(timestamp_in), "%Y-%m") AS period, 
         qname, 
         qdescr, 
         prefisso, 
         comune, 
         provincia, 
         regione, 
         Count(id)                                      AS total
  FROM   report_queue_callers 
  WHERE  regione IS NOT NULL
  GROUP  BY period, 
            qname, 
            regione 
  ORDER  BY period, 
            qname, 
            comune, 
            provincia, 
            regione; 

CREATE TABLE distribution_geo_week AS 
  SELECT Date_format(From_unixtime(timestamp_in), "%Y-%u") AS period, 
         qname, 
         qdescr, 
         prefisso, 
         comune, 
         provincia, 
         regione, 
         Count(id)                                      AS total
  FROM   report_queue_callers 
  WHERE  regione IS NOT NULL
  GROUP  BY period, 
            qname, 
            regione 
  ORDER  BY period, 
            qname, 
            comune, 
            provincia, 
            regione; 

CREATE TABLE distribution_geo_day AS 
  SELECT Date_format(From_unixtime(timestamp_in), "%Y-%m-%d") AS period, 
         qname, 
         qdescr, 
         prefisso, 
         comune, 
         provincia, 
         regione, 
         Count(id)                                      AS total
  FROM   report_queue_callers 
  WHERE  regione IS NOT NULL
  GROUP  BY period, 
            qname, 
            regione 
  ORDER  BY period, 
            qname, 
            comune, 
            provincia, 
            regione;
