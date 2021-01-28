SELECT
    did,
    hour,
    total AS total£num
FROM dashboard_cdr_11_{{ .Time.CdrDashboardRange }}
