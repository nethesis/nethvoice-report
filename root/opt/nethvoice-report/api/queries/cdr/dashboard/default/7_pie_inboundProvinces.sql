SELECT
    province,
    total
FROM dashboard_cdr_7_{{ .Time.CdrDashboardRange }}
