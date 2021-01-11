SELECT
    province,
    total
FROM dashboard_cdr_13_{{ .Time.CdrDashboardRange }}
