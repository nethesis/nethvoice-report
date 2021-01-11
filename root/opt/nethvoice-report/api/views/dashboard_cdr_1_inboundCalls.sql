/* 1 - Total INBOUND call per Route */

/* VARIABLES */
SELECT CONCAT('cdr_', DATE_FORMAT(NOW() - INTERVAL 1 YEAR - INTERVAL 1 DAY, "%Y")) INTO @from;
SELECT CONCAT('cdr_', DATE_FORMAT(NOW() - INTERVAL 1 DAY, "%Y")) INTO @to;

/* DROPS */
DROP TABLE IF EXISTS dashboard_cdr_1_past_week;
DROP TABLE IF EXISTS dashboard_cdr_1_current_week;
DROP TABLE IF EXISTS dashboard_cdr_1_past_month;
DROP TABLE IF EXISTS dashboard_cdr_1_current_month;
DROP TABLE IF EXISTS dashboard_cdr_1_past_quarter;
DROP TABLE IF EXISTS dashboard_cdr_1_past_semester;
DROP TABLE IF EXISTS dashboard_cdr_1_past_year;
DROP TABLE IF EXISTS dashboard_cdr_1_current_year;

/* QUERIES */
SET @q_past_year = CONCAT('
CREATE TABLE dashboard_cdr_1_past_year AS
SELECT inbound, sum(total) AS total FROM
       (SELECT Substring_index(Substring_index(channel, \'-\', 1), \'/\', -1) AS inbound, 
              Count(*)                                                   AS total 
       FROM   ',@from,' 
       WHERE  type = "IN" 
              AND calldate >= (SELECT MAKEDATE(YEAR(NOW()-INTERVAL 1 YEAR),1)) 
              AND calldate <= (SELECT LAST_DAY(DATE_ADD(NOW()-INTERVAL 1 YEAR, INTERVAL 12-MONTH(NOW()-INTERVAL 1 YEAR) MONTH)))
       GROUP BY inbound	
       UNION ALL
       SELECT Substring_index(Substring_index(channel, \'-\', 1), \'/\', -1) AS inbound, 
              Count(*)                                                   AS total 
       FROM   ',@to,'
       WHERE  type = "IN" 
              AND calldate >= (SELECT MAKEDATE(YEAR(NOW()-INTERVAL 1 YEAR),1))
              AND calldate <= (SELECT LAST_DAY(DATE_ADD(NOW()-INTERVAL 1 YEAR, INTERVAL 12-MONTH(NOW()-INTERVAL 1 YEAR) MONTH)))
       GROUP BY inbound
       ) t
WHERE  inbound IS NOT NULL
GROUP  BY inbound
ORDER  BY total DESC');
SET @q_current_year = CONCAT('
CREATE TABLE dashboard_cdr_1_current_year AS SELECT inbound, sum(total) AS total FROM
       (SELECT Substring_index(Substring_index(channel, \'-\', 1), \'/\', -1) AS inbound,
              Count(*)                                                   AS total
       FROM   ',@from,'
       WHERE  type = "IN"
              AND calldate >= (SELECT MAKEDATE(YEAR(NOW()),1))
              AND calldate <= (SELECT LAST_DAY(DATE_ADD(NOW(), INTERVAL 12-MONTH(NOW()) MONTH)))
       GROUP BY inbound
       UNION ALL
       SELECT Substring_index(Substring_index(channel, \'-\', 1), \'/\', -1) AS inbound,
              Count(*)                                                   AS total
       FROM   ',@to,'
       WHERE  type = "IN"
              AND calldate >= (SELECT MAKEDATE(YEAR(NOW()),1))
              AND calldate <= (SELECT LAST_DAY(DATE_ADD(NOW(), INTERVAL 12-MONTH(NOW()) MONTH)))
       GROUP BY inbound
       ) t
WHERE  inbound IS NOT NULL
GROUP  BY inbound
ORDER  BY total DESC');
SET @q_past_semester = CONCAT('
CREATE TABLE dashboard_cdr_1_past_semester AS SELECT inbound, sum(total) AS total FROM
       (SELECT Substring_index(Substring_index(channel, \'-\', 1), \'/\', -1) AS inbound,
              Count(*)                                                   AS total
       FROM   ',@from,'
       WHERE  type = "IN"
              AND calldate >= (SELECT DATE_FORMAT(NOW()-INTERVAL 6 MONTH, "%Y-%m-01"))
              AND calldate <= (SELECT LAST_DAY(NOW()-INTERVAL 6 MONTH))
       GROUP BY inbound
       UNION ALL
       SELECT Substring_index(Substring_index(channel, \'-\', 1), \'/\', -1) AS inbound,
              Count(*)                                                   AS total
       FROM   ',@to,'
       WHERE  type = "IN"
              AND calldate >= (SELECT DATE_FORMAT(NOW()-INTERVAL 6 MONTH, "%Y-%m-01"))
              AND calldate <= (SELECT LAST_DAY(NOW()-INTERVAL 6 MONTH))
       GROUP BY inbound
       ) t
WHERE  inbound IS NOT NULL
GROUP  BY inbound
ORDER  BY total DESC');
SET @q_past_quarter = CONCAT('
CREATE TABLE dashboard_cdr_1_past_quarter AS SELECT inbound, sum(total) AS total FROM
       (SELECT Substring_index(Substring_index(channel, \'-\', 1), \'/\', -1) AS inbound,
              Count(*)                                                   AS total
       FROM   ',@from,'
       WHERE  type = "IN"
              AND calldate >= (SELECT DATE_FORMAT(NOW()-INTERVAL 3 MONTH, "%Y-%m-01"))
              AND calldate <= (SELECT LAST_DAY(NOW()-INTERVAL 3 MONTH))
       GROUP BY inbound
       UNION ALL
       SELECT Substring_index(Substring_index(channel, \'-\', 1), \'/\', -1) AS inbound,
              Count(*)                                                   AS total
       FROM   ',@to,'
       WHERE  type = "IN"
              AND calldate >= (SELECT DATE_FORMAT(NOW()-INTERVAL 3 MONTH, "%Y-%m-01"))
              AND calldate <= (SELECT LAST_DAY(NOW()-INTERVAL 3 MONTH))
       GROUP BY inbound
       ) t
WHERE  inbound IS NOT NULL
GROUP  BY inbound
ORDER  BY total DESC');
SET @q_past_month = CONCAT('
CREATE TABLE dashboard_cdr_1_past_month AS SELECT inbound, sum(total) AS total FROM
       (SELECT Substring_index(Substring_index(channel, \'-\', 1), \'/\', -1) AS inbound,
              Count(*)                                                   AS total
       FROM   ',@from,'
       WHERE  type = "IN"
              AND calldate >= (SELECT DATE_FORMAT(NOW()-INTERVAL 1 MONTH, "%Y-%m-01"))
              AND calldate <= (SELECT LAST_DAY(NOW()-INTERVAL 1 MONTH))
       GROUP BY inbound
       UNION ALL
       SELECT Substring_index(Substring_index(channel, \'-\', 1), \'/\', -1) AS inbound,
              Count(*)                                                   AS total
       FROM   ',@to,'
       WHERE  type = "IN"
              AND calldate >= (SELECT DATE_FORMAT(NOW()-INTERVAL 1 MONTH, "%Y-%m-01"))
              AND calldate <= (SELECT LAST_DAY(NOW()-INTERVAL 1 MONTH))
       GROUP BY inbound
       ) t
WHERE  inbound IS NOT NULL
GROUP  BY inbound
ORDER  BY total DESC');
SET @q_current_month = CONCAT('
CREATE TABLE dashboard_cdr_1_current_month AS SELECT inbound, sum(total) AS total FROM
       (SELECT Substring_index(Substring_index(channel, \'-\', 1), \'/\', -1) AS inbound,
              Count(*)                                                   AS total
       FROM   ',@from,'
       WHERE  type = "IN"
              AND calldate >= (SELECT DATE_FORMAT(NOW(), "%Y-%m-01"))
              AND calldate <= (SELECT LAST_DAY(NOW()))
       GROUP BY inbound
       UNION ALL
       SELECT Substring_index(Substring_index(channel, \'-\', 1), \'/\', -1) AS inbound,
              Count(*)                                                   AS total
       FROM   ',@to,'
       WHERE  type = "IN"
              AND calldate >= (SELECT DATE_FORMAT(NOW(), "%Y-%m-01"))
              AND calldate <= (SELECT LAST_DAY(NOW()))
       GROUP BY inbound
       ) t
WHERE  inbound IS NOT NULL
GROUP  BY inbound
ORDER  BY total DESC');
SET @q_past_week = CONCAT('
CREATE TABLE dashboard_cdr_1_past_week AS SELECT inbound, sum(total) AS total FROM
       (SELECT Substring_index(Substring_index(channel, \'-\', 1), \'/\', -1) AS inbound,
              Count(*)                                                   AS total
       FROM   ',@from,'
       WHERE  type = "IN"
              AND calldate >= (SELECT DATE_FORMAT(DATE_ADD(NOW()-INTERVAL 1 WEEK, INTERVAL(-WEEKDAY(NOW()-INTERVAL 1 WEEK)) DAY), "%Y-%m-%d"))
              AND calldate <= (SELECT DATE_FORMAT(DATE_ADD(DATE_ADD(NOW()-INTERVAL 1 WEEK, INTERVAL(-WEEKDAY(NOW()-INTERVAL 1 WEEK)) DAY), INTERVAL 6 DAY), "%Y-%m-%d"))
       GROUP BY inbound
       UNION ALL
       SELECT Substring_index(Substring_index(channel, \'-\', 1), \'/\', -1) AS inbound,
              Count(*)                                                   AS total
       FROM   ',@to,'
       WHERE  type = "IN"
              AND calldate >= (SELECT DATE_FORMAT(DATE_ADD(NOW()-INTERVAL 1 WEEK, INTERVAL(-WEEKDAY(NOW()-INTERVAL 1 WEEK)) DAY), "%Y-%m-%d"))
              AND calldate <= (SELECT DATE_FORMAT(DATE_ADD(DATE_ADD(NOW()-INTERVAL 1 WEEK, INTERVAL(-WEEKDAY(NOW()-INTERVAL 1 WEEK)) DAY), INTERVAL 6 DAY), "%Y-%m-%d"))
       GROUP BY inbound
       ) t
WHERE  inbound IS NOT NULL
GROUP  BY inbound
ORDER  BY total DESC');
SET @q_current_week = CONCAT('
CREATE TABLE dashboard_cdr_1_current_week AS SELECT inbound, sum(total) AS total FROM
       (SELECT Substring_index(Substring_index(channel, \'-\', 1), \'/\', -1) AS inbound,
              Count(*)                                                   AS total
       FROM   ',@from,'
       WHERE  type = "IN"
              AND calldate >= (SELECT DATE_FORMAT(DATE_ADD(NOW(), INTERVAL(-WEEKDAY(NOW())) DAY), "%Y-%m-%d"))
              AND calldate <= (SELECT DATE_FORMAT(DATE_ADD(DATE_ADD(NOW(), INTERVAL(-WEEKDAY(NOW())) DAY), INTERVAL 6 DAY), "%Y-%m-%d"))
       GROUP BY inbound
       UNION ALL
       SELECT Substring_index(Substring_index(channel, \'-\', 1), \'/\', -1) AS inbound,
              Count(*)                                                   AS total
       FROM   ',@to,'
       WHERE  type = "IN"
              AND calldate >= (SELECT DATE_FORMAT(DATE_ADD(NOW(), INTERVAL(-WEEKDAY(NOW())) DAY), "%Y-%m-%d"))
              AND calldate <= (SELECT DATE_FORMAT(DATE_ADD(DATE_ADD(NOW(), INTERVAL(-WEEKDAY(NOW())) DAY), INTERVAL 6 DAY), "%Y-%m-%d"))
       GROUP BY inbound
       ) t
WHERE  inbound IS NOT NULL
GROUP  BY inbound
ORDER  BY total DESC');

/* STATMENTS */
PREPARE stmt_past_year from @q_past_year;
PREPARE stmt_current_year from @q_current_year;
PREPARE stmt_past_semester from @q_past_semester;
PREPARE stmt_past_quarter from @q_past_quarter;
PREPARE stmt_past_month from @q_past_month;
PREPARE stmt_current_month from @q_current_month;
PREPARE stmt_past_week from @q_past_week;
PREPARE stmt_current_week from @q_current_week;
EXECUTE stmt_past_year;
EXECUTE stmt_current_year;
EXECUTE stmt_past_semester;
EXECUTE stmt_past_quarter;
EXECUTE stmt_past_month;
EXECUTE stmt_current_month;
EXECUTE stmt_past_week;
EXECUTE stmt_current_week;
DEALLOCATE PREPARE stmt_past_year;
DEALLOCATE PREPARE stmt_current_year;
DEALLOCATE PREPARE stmt_past_semester;
DEALLOCATE PREPARE stmt_past_quarter;
DEALLOCATE PREPARE stmt_past_month;
DEALLOCATE PREPARE stmt_current_month;
DEALLOCATE PREPARE stmt_past_week;
DEALLOCATE PREPARE stmt_current_week;