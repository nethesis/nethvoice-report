-- //// remove test query
select
    src,
    dst,
    type,
    DATE_FORMAT(calldate, '%Y-%m-%d %H:%i:%s') AS time
    from `<CDR_TABLE>`
    where
        calldate >= "{{ .Time.Interval.Start }}"
        and calldate <= "{{ .Time.Interval.End }}"
