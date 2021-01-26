SELECT
    did,
    hour,
    total AS total£num
FROM dashboard_cdr_17_{{ .Time.CdrDashboardRange }}
