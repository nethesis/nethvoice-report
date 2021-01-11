SELECT
    outbound,
    total
FROM dashboard_cdr_8_{{ .Time.CdrDashboardRange }}
