CREATE TABLE IF NOT EXISTS `cdr_{{ YearMap .Year }}`
(
	`call_type` TEXT DEFAULT '',
	`cost` DOUBLE DEFAULT NULL, UNIQUE KEY uniq (calldate,uniqueid,dstchannel,duration),
	`dispositions` LONGTEXT DEFAULT ''
)
SELECT `calldate`,
       `clid`,
       `src`,
       `dst`,
       `dcontext`,
       `channel`,
       `dstchannel`,
       `lastapp`,
       `lastdata`,
       MAX(`duration`) as duration,
       IF (MIN(`disposition`) = 'ANSWERED', MAX(billsec), MIN(billsec)) as billsec,
       `disposition`,
       `amaflags`,
       `accountcode`,
       `uniqueid`,
       `userfield`,
       `did`,
       `recordingfile`,
       `cnum`,
       `cnam`,
       `outbound_cnum`,
       `outbound_cnam`,
       `dst_cnam`,
       `linkedid`,
       `peeraccount`,
       `sequence`,
       `ccompany`,
       `dst_ccompany`,
       IF(Substring_index(SUBSTRING(channel,1,LENGTH(channel)-LOCATE('-',REVERSE(channel))), '/', -1) IN

             (SELECT channelid
                                                                         FROM
             asterisk.trunks), "IN", IF(Substring_index(SUBSTRING(dstchannel,1,LENGTH(dstchannel)-LOCATE('-',REVERSE(dstchannel))), '/', -1) IN (
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
SELECT `calldate`,
       `clid`,
       `src`,
       `dst`,
       `dcontext`,
       `channel`,
       `dstchannel`,
       `lastapp`,
       `lastdata`,
       MAX(`duration`) as duration,
       IF (MIN(`disposition`) = 'ANSWERED', MAX(billsec), MIN(billsec)) as billsec,
       `disposition`,
       `amaflags`,
       `accountcode`,
       `uniqueid`,
       `userfield`,
       `did`,
       `recordingfile`,
       `cnum`,
       `cnam`,
       `outbound_cnum`,
       `outbound_cnam`,
       `dst_cnam`,
       `linkedid`,
       `peeraccount`,
       `sequence`,
       `ccompany`,
       `dst_ccompany`,
       IF(Substring_index(SUBSTRING(channel,1,LENGTH(channel)-LOCATE('-',REVERSE(channel))), '/', -1) IN
             (SELECT channelid
                                                                         FROM
             asterisk.trunks), "IN", IF( Substring_index(SUBSTRING(dstchannel,1,LENGTH(dstchannel)-LOCATE('-',REVERSE(dstchannel))), '/', -1) IN (
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
