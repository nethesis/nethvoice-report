var UiMaps = {
  data() {
    return {
      filtersMap: {
        "queue": {
          "dashboard": {
            "default": ["time", "queue", "agent", "ivr", "choice"],
          },
          "data": {
            "summary": ["timeGroup", "time", "queue", "agent"],
            "agent": ["timeGroup", "time", "queue", "agent"],
            "session": ["time", "hour", "queue", "reason", "agent"],
            "caller": ["timeGroup", "time", "queue", "caller", "contactName"],
            "call": ["time", "hour", "queue", "caller", "contactName", "agent", "result"],
            "lost_call": ["timeGroup", "time", "queue", "caller", "contactName", "reason"],
            "ivr": ["timeGroup", "time", "ivr", "choice"]
          },
          "performance": {
            "default": ["timeGroup", "time", "queue"]
          },
          "distribution": {
            "hourly": ["timeGroup", "time", "queue", "timeSplit", "agent", "ivr"],
            "geographic": ["timeGroup", "time", "queue", "origin"],
          },
          "graphs": {
            "load": ["timeGroup", "time", "queue", "origin"],
            "hour": ["time", "queue", "agent", "destination", "ivr", "choice"],
            "agent": ["timeGroup", "time", "queue", "agent"],
            "area": ["timeGroup", "time", "queue"],
            "queue_position": ["time", "queue", "timeSplit"],
            "avg_duration": ["time", "queue", "timeSplit"],
            "avg_wait": ["time", "queue", "timeSplit"]
          }
        },
        "cdr": {
          "dashboard": {
            "default": ["cdr_fastTimeRange", "cdr_caller", "cdr_callee", "cdr_callType", "cdr_callDuration", "cdr_trunk"],
          },
          "pbx_data": {
            "incoming_calls": ["cdr_fastTimeRange", "cdr_caller", "cdr_callee", "cdr_callType", "cdr_callDuration", "cdr_trunk", "cdr_ctiGroups", "cdr_user", "cdr_destinationType"],
            "outgoing_calls": ["cdr_fastTimeRange", "cdr_caller", "cdr_callee", "cdr_callType", "cdr_callDuration", "cdr_trunk", "cdr_ctiGroups", "cdr_user", "cdr_destination"],
            "internal_calls": ["cdr_fastTimeRange", "cdr_caller", "cdr_callee", "cdr_callType", "cdr_callDuration", "cdr_user", "cdr_ctiGroups"],
          },
          "personal_data": {
            "incoming_calls": ["cdr_fastTimeRange", "cdr_caller", "cdr_callee", "cdr_callType", "cdr_callDuration", "cdr_trunk", "cdr_destinationType"],
            "outgoing_calls": ["cdr_fastTimeRange", "cdr_caller", "cdr_callee", "cdr_callType", "cdr_callDuration", "cdr_trunk", "cdr_destination"],
            "internal_calls": ["cdr_fastTimeRange", "cdr_caller", "cdr_callee", "cdr_callType", "cdr_callDuration"],
          },
        }
      },
      groupByTimeValuesMap: [
        { value: "day", text: this.$i18n.t('filter.day') },
        { value: "week", text: this.$i18n.t('filter.week') },
        { value: "month", text: this.$i18n.t('filter.month') },
        { value: "year", text: this.$i18n.t('filter.year') },
      ],
      splitByTimeValuesMap: [
        { value: "60", text: "1 hour" },
        { value: "30", text: "30 minutes" },
        { value: "15", text: "15 minutes" },
        { value: "10", text: "10 minutes" },
      ],
      fastCdrTimeRangeValuesMap: [
        { value: "yesterday", text: this.$i18n.t('filter.yesterday') },
        { value: "last_two_days", text: this.$i18n.t('filter.last_two_days') },
        { value: "current_week", text: this.$i18n.t('filter.current_week') },
        { value: "last_week", text: this.$i18n.t('filter.last_week') },
        { value: "current_month", text: this.$i18n.t('filter.current_month') },
        { value: "last_month", text: this.$i18n.t('filter.last_month') },
        { value: "last_two_months", text: this.$i18n.t('filter.last_two_months') },
        { value: "last_three_months", text: this.$i18n.t('filter.last_three_months') },
        { value: "last_six_months", text: this.$i18n.t('filter.last_six_months') },
        { value: "current_year", text: this.$i18n.t('filter.current_year') },
        { value: "last_year", text: this.$i18n.t('filter.last_year') },
      ],
      cdrCallDurationMap: [
        { value: "60", text: this.$i18n.t('filter.one_minute') },
        { value: "300", text: this.$i18n.t('filter.five_minutes') },
        { value: "900", text: this.$i18n.t('filter.fifteen_minutes') },
        { value: "1800", text: this.$i18n.t('filter.thirti_minutes') },
        { value: "3600", text: this.$i18n.t('filter.one_hour') },
        { value: "7200", text: this.$i18n.t('filter.two_hours') }
      ],
      cdrCallTypeMap: [
        { value: "done", text: this.$i18n.t('filter.done') },
        { value: "done_answered", text: this.$i18n.t('filter.done_answered') },
        { value: "done_not_answered", text: this.$i18n.t('filter.done_not_answered') },
        { value: "done_fail", text: this.$i18n.t('filter.done_fail') },
        { value: "received", text: this.$i18n.t('filter.received') },
        { value: "received_answered", text: this.$i18n.t('filter.received_answered') },
        { value: "received_not_answered", text: this.$i18n.t('filter.received_not_answered') },
        { value: "received_fail", text: this.$i18n.t('filter.received_fail') }
      ],
      destinationsTypeMap: [
        { value: "ext-group", text: this.$i18n.t('filter.call_groups') },
        { value: "VoiceMail", text: this.$i18n.t('filter.voicemails') },
        { value: "queue", text: this.$i18n.t('filter.queues') },
      ],
      calleeTypeMap: [
        { value: "mobile", text: this.$i18n.t('filter.mobile') },
        { value: "international", text: this.$i18n.t('filter.international') },
        { value: "fixed", text: this.$i18n.t('filter.fixed') },
      ]
    }
  }
}
export default UiMaps;
