SELECT
    region,
    total
FROM dashboard_cdr_12_{{ .Time.CdrDashboardRange }}
