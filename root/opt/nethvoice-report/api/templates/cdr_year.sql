CREATE TABLE IF NOT EXISTS `cdr_{{ YearMap .Year }}` AS
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
       Group_concat(lastapp, "")           AS lastapps
FROM   cdr c
WHERE  uniqueid = linkedid
       AND date_format(calldate, "%Y") = "{{ .Year }}"
GROUP  BY linkedid,
          peeraccount
ORDER  BY calldate;

ALTER TABLE `cdr_{{ YearMap .Year }}` ADD UNIQUE (calldate,uniqueid,dstchannel);

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
       Group_concat(lastapp, "")           AS lastapps
FROM   cdr c
WHERE  uniqueid = linkedid
       AND date_format(calldate, "%Y") = "{{ .Year }}"
       AND date_format(calldate, "%Y-%m-%d") = date_format(NOW() - INTERVAL 1 DAY, "%Y-%m-%d")
GROUP  BY linkedid,
          peeraccount
ORDER  BY calldate;
