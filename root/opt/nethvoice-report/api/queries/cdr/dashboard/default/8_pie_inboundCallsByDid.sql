SELECT
    did,
    total AS total£num
FROM dashboard_cdr_14_{{ .Time.CdrDashboardRange }}
