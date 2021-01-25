CREATE TABLE IF NOT EXISTS `cdr_{{ YearMap .Year }}`
(
	`call_type` TEXT DEFAULT '',
	`cost` DOUBLE DEFAULT NULL, UNIQUE KEY uniq (calldate,uniqueid,dstchannel)
)
SELECT *,
       IF(Substring_index(Substring_index(channel, '-', 1), '/', -1) IN
             (SELECT channelid
                                                                         FROM
             asterisk.trunks), "IN", IF(Substring_index(Substring_index(
                                                        dstchannel, '-'
                                                        , 1), '/', -1) IN (
                                        SELECT
                                                                      channelid
                                        FROM
       asterisk.trunks), "OUT", "LOCAL"))  AS type,
       Group_concat(disposition, "")       AS dispositions,
       Group_concat(lastapp, "")           AS lastapps,
       Group_concat(dcontext, "")          AS dcontexts,
       {{ ExtractPatterns }}               AS call_type,
       NULL                                AS cost
FROM   cdr c
WHERE  uniqueid = linkedid
       AND date_format(calldate, "%Y") = "{{ .Year }}"
GROUP  BY linkedid,
          peeraccount
ORDER  BY calldate;

INSERT IGNORE INTO `cdr_{{ YearMap .Year }}`
SELECT *,
       IF(Substring_index(Substring_index(channel, '-', 1), '/', -1) IN
             (SELECT channelid
                                                                         FROM
             asterisk.trunks), "IN", IF(Substring_index(Substring_index(
                                                        dstchannel, '-'
                                                        , 1), '/', -1) IN (
                                        SELECT
                                                                      channelid
                                        FROM
       asterisk.trunks), "OUT", "LOCAL"))  AS type,
       Group_concat(disposition, "")       AS dispositions,
       Group_concat(lastapp, "")           AS lastapps,
       Group_concat(dcontext, "")          AS dcontexts,
       {{ ExtractPatterns }}               AS call_type,
       NULL                                AS cost
FROM   cdr c
WHERE  uniqueid = linkedid
       AND date_format(calldate, "%Y") = "{{ .Year }}"
       AND date_format(calldate, "%Y-%m-%d") = date_format(NOW() - INTERVAL 1 DAY, "%Y-%m-%d")
GROUP  BY linkedid,
          peeraccount
ORDER  BY calldate;

UPDATE `cdr_{{ YearMap .Year }}` SET call_type = "" WHERE type = "IN";
UPDATE `cdr_{{ YearMap .Year }}` SET call_type = "" WHERE type = "LOCAL";
