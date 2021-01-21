CREATE TABLE IF NOT EXISTS `cdr_{{ YearMap .Year }}-{{ MonthMap .Month }}`
(UNIQUE KEY uniq (calldate,uniqueid,dstchannel))
SELECT *
FROM `cdr_{{ YearMap .Year }}`
WHERE date_format(calldate, "%Y-%m") = "{{ .Year }}-{{ MonthMap .Month }}";

INSERT IGNORE INTO `cdr_{{ YearMap .Year }}-{{ MonthMap .Month }}`
SELECT *
FROM `cdr_{{ YearMap .Year }}`
WHERE  date_format(calldate, "%Y-%m") = "{{ .Year }}-{{ MonthMap .Month }}"
       AND date_format(calldate, "%Y-%m-%d") = date_format(NOW() - INTERVAL 1 DAY, "%Y-%m-%d");
