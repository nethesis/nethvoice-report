SELECT (SELECT SUM(count) 
        FROM   performance_qos_total 
        WHERE  TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
               {{ end }} 
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}) 
       AS total, 
       (SELECT SUM(count) AS count 
        FROM   performance_qos_total_5 
        WHERE  TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
               {{ end }} 
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}) 
       AS 5count, 
       ( Round((SELECT SUM(count) AS count 
                FROM   performance_qos_total_5 
                WHERE  TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
                       {{ end }} 
                       {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}) * 100 / (SELECT SUM(count) 
                                                    FROM   performance_qos_total 
                                                    WHERE 
               TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
	       {{ end }}
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}), 2) ) AS 
       5count£percent, 
       (SELECT SUM(count) AS count 
        FROM   performance_qos_total_10 
        WHERE  TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
               {{ end }} 
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}) 
       AS 10count, 
       ( Round((SELECT SUM(count) AS count 
                FROM   performance_qos_total_10 
                WHERE  TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
                       {{ end }} 
                       {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}) * 100 / (SELECT SUM(count) 
                                                    FROM   performance_qos_total 
                                                    WHERE 
               TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
	       {{ end }} 
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}), 2) ) AS 
       10count£percent, 
       (SELECT SUM(count) AS count 
        FROM   performance_qos_total_15 
        WHERE  TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
               {{ end }} 
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}) 
       AS 15count, 
       ( Round((SELECT SUM(count) AS count 
                FROM   performance_qos_total_15 
                WHERE  TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
                       {{ end }} 
                       {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}) * 100 / (SELECT SUM(count) 
                                                    FROM   performance_qos_total 
                                                    WHERE 
               TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
	       {{ end  }}
	       {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}), 2) ) AS 
       15count£percent, 
       (SELECT SUM(count) AS count 
        FROM   performance_qos_total_20 
        WHERE  TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
               {{ end }} 
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}) 
       AS 20count, 
       ( Round((SELECT SUM(count) AS count 
                FROM   performance_qos_total_20 
                WHERE  TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
                       {{ end }} 
                       {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}) * 100 / (SELECT SUM(count) 
                                                    FROM   performance_qos_total 
                                                    WHERE 
               TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
	       {{ end }}
	       {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}), 2) ) AS 
       20count£percent, 
       (SELECT SUM(count) AS count 
        FROM   performance_qos_total_25 
        WHERE  TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
               {{ end }} 
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}) 
       AS 25count, 
       ( Round((SELECT SUM(count) AS count 
                FROM   performance_qos_total_25 
                WHERE  TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
                       {{ end }} 
                       {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}) * 100 / (SELECT SUM(count) 
                                                    FROM   performance_qos_total 
                                                    WHERE 
               TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
	       {{ end }}
	       {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}), 2) ) AS 
       25count£percent, 
       (SELECT SUM(count) AS count 
        FROM   performance_qos_total_30 
        WHERE  TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
               {{ end }} 
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}) 
       AS 30count, 
       ( Round((SELECT SUM(count) AS count 
                FROM   performance_qos_total_30 
                WHERE  TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
                       {{ end }} 
                       {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}) * 100 / (SELECT SUM(count) 
                                                    FROM   performance_qos_total 
                                                    WHERE 
               TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
	       {{ end }}
	       {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}), 2) ) AS 
       30count£percent, 
       (SELECT SUM(count) AS count 
        FROM   performance_qos_total_45 
        WHERE  TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
               {{ end }} 
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}) 
       AS 45count, 
       ( Round((SELECT SUM(count) AS count 
                FROM   performance_qos_total_45 
                WHERE  TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
                       {{ end }} 
                       {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}) * 100 / (SELECT SUM(count) 
                                                    FROM   performance_qos_total 
                                                    WHERE 
               TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
	       {{ end }}
	       {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}), 2) ) AS 
       45count£percent, 
       (SELECT SUM(count) AS count 
        FROM   performance_qos_total_60 
        WHERE  TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
               {{ end }} 
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}) 
       AS 60count, 
       ( Round((SELECT SUM(count) AS count 
                FROM   performance_qos_total_60 
                WHERE  TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
                       {{ end }} 
                       {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}) * 100 / (SELECT SUM(count) 
                                                    FROM   performance_qos_total 
                                                    WHERE 
               TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
	       {{ end }}
	       {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}), 2) ) AS 
       60count£percent, 
       (SELECT SUM(count) AS count 
        FROM   performance_qos_total_75 
        WHERE  TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
               {{ end }} 
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}) 
       AS 75count, 
       ( Round((SELECT SUM(count) AS count 
                FROM   performance_qos_total_75 
                WHERE  TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
                       {{ end }} 
                       {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}) * 100 / (SELECT SUM(count) 
                                                    FROM   performance_qos_total 
                                                    WHERE 
               TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
	       {{ end }}
	       {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}), 2) ) AS 
       75count£percent, 
       (SELECT SUM(count) AS count 
        FROM   performance_qos_total_90 
        WHERE  TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
               {{ end }} 
               {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}) 
       AS 90count, 
       ( Round((SELECT SUM(count) AS count 
                FROM   performance_qos_total_90 
                WHERE  TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
                       {{ end }} 
                       {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}) * 100 / (SELECT SUM(count) 
                                                    FROM   performance_qos_total 
                                                    WHERE 
               TRUE {{ if and .Time.Interval.Start .Time.Interval.End }}
               AND timestamp_in >= "{{ .Time.Interval.Start }}"
               AND timestamp_out <= "{{ .Time.Interval.End }}" 
	       {{ end }}
	       {{ if gt (len .Queues) 0 }}
               AND qname in ({{ StringsJoin .Queues "," }})
               {{ end }}), 2) ) AS 
       90count£percent; 
