SELECT
    outbound,
    total AS total£num
FROM dashboard_cdr_8_{{ .Time.CdrDashboardRange }}
