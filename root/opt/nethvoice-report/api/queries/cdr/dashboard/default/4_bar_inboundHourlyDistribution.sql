SELECT
    inbound,
    hour,
    total AS total£num
FROM dashboard_cdr_4_{{ .Time.CdrDashboardRange }}
