select
    src, dst, type
    from `<CDR_TABLE>`
    where
        calldate >= "{{ .Time.Interval.Start }}"
        and calldate <= "{{ .Time.Interval.End }}"
