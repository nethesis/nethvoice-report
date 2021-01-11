SELECT
    region,
    total
FROM dashboard_cdr_6_{{ .Time.CdrDashboardRange }}
