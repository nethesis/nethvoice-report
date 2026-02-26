CREATE TABLE IF NOT EXISTS `cdr_{{ YearMap .Year }}-{{ MonthMap .Month }}`
(UNIQUE KEY uniq (calldate,uniqueid,dstchannel,duration))
SELECT *
FROM `cdr_{{ YearMap .Year }}`
WHERE calldate >= '{{ YearMap .Year }}-{{ MonthMap .Month }}-01'
      AND calldate < '{{ YearMap .Year }}-{{ MonthMap .Month }}-01' + INTERVAL 1 MONTH;

INSERT IGNORE INTO `cdr_{{ YearMap .Year }}-{{ MonthMap .Month }}`
SELECT *
FROM `cdr_{{ YearMap .Year }}`
WHERE calldate >= DATE(NOW() - INTERVAL 1 DAY)
      AND calldate < DATE(NOW());

-- Indexes for query performance
ALTER TABLE `cdr_{{ YearMap .Year }}-{{ MonthMap .Month }}` ADD INDEX IF NOT EXISTS idx_type_calldate (type, calldate);
ALTER TABLE `cdr_{{ YearMap .Year }}-{{ MonthMap .Month }}` ADD INDEX IF NOT EXISTS idx_type (type);
ALTER TABLE `cdr_{{ YearMap .Year }}-{{ MonthMap .Month }}` ADD INDEX IF NOT EXISTS idx_cnum (cnum);
ALTER TABLE `cdr_{{ YearMap .Year }}-{{ MonthMap .Month }}` ADD INDEX IF NOT EXISTS idx_dst (dst);
ALTER TABLE `cdr_{{ YearMap .Year }}-{{ MonthMap .Month }}` ADD INDEX IF NOT EXISTS idx_calldate (calldate);
