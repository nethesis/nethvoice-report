CREATE TABLE IF NOT EXISTS `cdr_{{ YearMap .Year }}` AS
SELECT *
FROM cdr
WHERE date_format(calldate, '%Y') = {{ .Year }}
