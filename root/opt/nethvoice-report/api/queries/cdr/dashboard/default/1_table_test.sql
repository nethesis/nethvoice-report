-- //// remove test query
select
    linkedid,
    src AS src£phoneNumber,
    dst AS dst£phoneNumber,
    type AS call_type£label,
    DATE_FORMAT(calldate, '%Y-%m-%d %H:%i:%s') AS time,
    SUBSTRING_INDEX(dispositions, ',',- 1) AS result£label, -- get last disposition
    billsec,
    cost
    -- clid, dcontext, channel, dstchannel, lastapp, lastdata, duration, disposition, amaflags, accountcode, uniqueid, userfield, did, recordingfile, cnum, cnam, outbound_cnum, outbound_cnam, dst_cnam, peeraccount, sequence, ccompany, dst_ccompany, lastapps, dcontexts, call_type
    from `<CDR_TABLE>`
    where
        calldate >= "{{ .Time.Interval.Start }}"
        and calldate <= "{{ .Time.Interval.End }}"
