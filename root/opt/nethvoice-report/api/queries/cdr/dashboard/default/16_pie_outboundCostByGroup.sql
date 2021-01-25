SELECT
    cti_group,
    cost AS cost£currency
FROM dashboard_cdr_10_{{ .Time.CdrDashboardRange }}
