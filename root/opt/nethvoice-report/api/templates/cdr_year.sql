-- Pre-compute trunk list to avoid correlated subqueries (executed once, not per-row)
DROP TEMPORARY TABLE IF EXISTS _trunk_list;
CREATE TEMPORARY TABLE _trunk_list AS SELECT DISTINCT channelid FROM asterisk.trunks;
ALTER TABLE _trunk_list ADD PRIMARY KEY (channelid);

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
       IF(t_in.channelid IS NOT NULL, "IN",
          IF(t_out.channelid IS NOT NULL, "OUT", "LOCAL")) AS type,
       Group_concat(disposition, "")       AS dispositions,
       Group_concat(lastapp, "")           AS lastapps,
       Group_concat(dcontext, "")          AS dcontexts,
       {{ ExtractPatterns }}               AS call_type,
       NULL                                AS cost
FROM   cdr c
LEFT JOIN _trunk_list t_in ON t_in.channelid = get_trunk_name(c.channel)
LEFT JOIN _trunk_list t_out ON t_out.channelid = get_trunk_name(c.dstchannel)
WHERE  uniqueid = linkedid
       AND calldate >= '{{ YearMap .Year }}-01-01'
       AND calldate < '{{ YearMap .Year }}-01-01' + INTERVAL 1 YEAR
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
       IF(t_in.channelid IS NOT NULL, "IN",
          IF(t_out.channelid IS NOT NULL, "OUT", "LOCAL")) AS type,
       Group_concat(disposition, "")       AS dispositions,
       Group_concat(lastapp, "")           AS lastapps,
       Group_concat(dcontext, "")          AS dcontexts,
       {{ ExtractPatterns }}               AS call_type,
       NULL                                AS cost
FROM   cdr c
LEFT JOIN _trunk_list t_in ON t_in.channelid = get_trunk_name(c.channel)
LEFT JOIN _trunk_list t_out ON t_out.channelid = get_trunk_name(c.dstchannel)
WHERE  uniqueid = linkedid
       AND calldate >= DATE(NOW() - INTERVAL 1 DAY)
       AND calldate < DATE(NOW())
GROUP  BY linkedid,
          peeraccount
ORDER  BY calldate;

DROP TEMPORARY TABLE IF EXISTS _trunk_list;

UPDATE `cdr_{{ YearMap .Year }}` SET call_type = "" WHERE type = "IN";
UPDATE `cdr_{{ YearMap .Year }}` SET call_type = "" WHERE type = "LOCAL";

-- Indexes for query performance
ALTER TABLE `cdr_{{ YearMap .Year }}` ADD INDEX IF NOT EXISTS idx_type_calldate (type, calldate);
ALTER TABLE `cdr_{{ YearMap .Year }}` ADD INDEX IF NOT EXISTS idx_type (type);
ALTER TABLE `cdr_{{ YearMap .Year }}` ADD INDEX IF NOT EXISTS idx_cnum (cnum);
ALTER TABLE `cdr_{{ YearMap .Year }}` ADD INDEX IF NOT EXISTS idx_dst (dst);
ALTER TABLE `cdr_{{ YearMap .Year }}` ADD INDEX IF NOT EXISTS idx_channel (channel);
ALTER TABLE `cdr_{{ YearMap .Year }}` ADD INDEX IF NOT EXISTS idx_dstchannel (dstchannel);
ALTER TABLE `cdr_{{ YearMap .Year }}` ADD INDEX IF NOT EXISTS idx_type_cnum_calldate (type, cnum, calldate);

-- Add geo columns if not present
ALTER TABLE `cdr_{{ YearMap .Year }}` ADD COLUMN IF NOT EXISTS src_region VARCHAR(100) DEFAULT NULL;
ALTER TABLE `cdr_{{ YearMap .Year }}` ADD COLUMN IF NOT EXISTS src_province VARCHAR(100) DEFAULT NULL;
ALTER TABLE `cdr_{{ YearMap .Year }}` ADD COLUMN IF NOT EXISTS dst_region VARCHAR(100) DEFAULT NULL;
ALTER TABLE `cdr_{{ YearMap .Year }}` ADD COLUMN IF NOT EXISTS dst_province VARCHAR(100) DEFAULT NULL;

-- Build lookup table for unique inbound phone numbers (much smaller than full table)
DROP TEMPORARY TABLE IF EXISTS _geo_src_lookup;
CREATE TEMPORARY TABLE _geo_src_lookup AS
SELECT DISTINCT clean_prefix(IF(cnum IS NULL OR cnum = '', src, cnum)) AS clean_phone
FROM `cdr_{{ YearMap .Year }}`
WHERE type = 'IN' AND src_region IS NULL;

ALTER TABLE _geo_src_lookup ADD INDEX idx_phone (clean_phone);

-- Resolve geo for unique source phones (longest prefix match)
DROP TEMPORARY TABLE IF EXISTS _geo_src_resolved;
CREATE TEMPORARY TABLE _geo_src_resolved AS
SELECT gsl.clean_phone,
  (SELECT z.regione FROM zone z WHERE gsl.clean_phone LIKE CONCAT(z.prefisso, '%')
   ORDER BY LENGTH(z.prefisso) DESC LIMIT 1) AS region,
  (SELECT z.provincia FROM zone z WHERE gsl.clean_phone LIKE CONCAT(z.prefisso, '%')
   ORDER BY LENGTH(z.prefisso) DESC LIMIT 1) AS province
FROM _geo_src_lookup gsl;

ALTER TABLE _geo_src_resolved ADD INDEX idx_phone (clean_phone);

-- Update inbound geo columns
UPDATE `cdr_{{ YearMap .Year }}` c
JOIN _geo_src_resolved gsr
  ON clean_prefix(IF(c.cnum IS NULL OR c.cnum = '', c.src, c.cnum)) = gsr.clean_phone
SET c.src_region = gsr.region, c.src_province = gsr.province
WHERE c.type = 'IN' AND c.src_region IS NULL;

-- Same for outbound destination phones
DROP TEMPORARY TABLE IF EXISTS _geo_dst_lookup;
CREATE TEMPORARY TABLE _geo_dst_lookup AS
SELECT DISTINCT clean_prefix(dst) AS clean_phone
FROM `cdr_{{ YearMap .Year }}`
WHERE type = 'OUT' AND dst_region IS NULL;

ALTER TABLE _geo_dst_lookup ADD INDEX idx_phone (clean_phone);

DROP TEMPORARY TABLE IF EXISTS _geo_dst_resolved;
CREATE TEMPORARY TABLE _geo_dst_resolved AS
SELECT gdl.clean_phone,
  (SELECT z.regione FROM zone z WHERE gdl.clean_phone LIKE CONCAT(z.prefisso, '%')
   ORDER BY LENGTH(z.prefisso) DESC LIMIT 1) AS region,
  (SELECT z.provincia FROM zone z WHERE gdl.clean_phone LIKE CONCAT(z.prefisso, '%')
   ORDER BY LENGTH(z.prefisso) DESC LIMIT 1) AS province
FROM _geo_dst_lookup gdl;

ALTER TABLE _geo_dst_resolved ADD INDEX idx_phone (clean_phone);

UPDATE `cdr_{{ YearMap .Year }}` c
JOIN _geo_dst_resolved gdr ON clean_prefix(c.dst) = gdr.clean_phone
SET c.dst_region = gdr.region, c.dst_province = gdr.province
WHERE c.type = 'OUT' AND c.dst_region IS NULL;

-- Add indexes on geo columns
ALTER TABLE `cdr_{{ YearMap .Year }}` ADD INDEX IF NOT EXISTS idx_src_region (type, src_region);
ALTER TABLE `cdr_{{ YearMap .Year }}` ADD INDEX IF NOT EXISTS idx_dst_region (type, dst_region);

-- Cleanup
DROP TEMPORARY TABLE IF EXISTS _geo_src_lookup;
DROP TEMPORARY TABLE IF EXISTS _geo_src_resolved;
DROP TEMPORARY TABLE IF EXISTS _geo_dst_lookup;
DROP TEMPORARY TABLE IF EXISTS _geo_dst_resolved;
