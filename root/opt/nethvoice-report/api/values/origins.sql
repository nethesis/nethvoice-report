SELECT DISTINCT CONCAT(comune,",",provincia,",",regione) FROM report_queue_callers WHERE CONCAT(comune,",",provincia,",",regione) NOT LIKE "" ORDER BY CONCAT(comune,",",provincia,",",regione);
