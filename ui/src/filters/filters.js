import Vue from "vue"
import lodash from 'lodash';
import moment from "moment";
import languages from "../i18n/lang";

var locale = languages.initLang().locale;
moment.locale(locale);

var Filters = {
    formatDate(date) {
        var d = new Date(date),
            month = '' + (d.getMonth() + 1),
            day = '' + d.getDate(),
            year = d.getFullYear();

        if (month.length < 2)
            month = '0' + month;
        if (day.length < 2)
            day = '0' + day;

        return [year, month, day].join('-');
    },
    formatMonthDate(value) {
        // value: e.g. "2020-10"
        const monthYear = moment(value, "YYYY-MM").format("MMMM YYYY");
        return lodash.upperFirst(monthYear);
    },
    formatWeekDate(value, i18n) {
        // value: e.g. "2020-50"
        const tokens = value.split("-W");
        const year = tokens[0];
        const weekNum = parseInt(tokens[1]);
        const firstDay = moment().year(year).week(weekNum).day(0).format('YYYY-MM-DD');
        const lastDay = moment().year(year).week(weekNum).day(6).format('YYYY-MM-DD');
        return (i18n ? i18n.t("misc.week") : "week") + " " + weekNum + " (" + firstDay + " - " + lastDay + ")";
    },
    formatNumber(value) {
        const num = parseFloat(value);

        if (isNaN(num)) {
            return "-";
        }
        return num.toLocaleString();
    },
    formatPercentage(value) {
        const num = parseFloat(value);

        if (isNaN(num)) {
            return "-";
        }
        return num.toLocaleString() + " %";
    },
    formatTime: function (value) {
        if (value != 0 && (!value || value.length == 0)) {
            return '-'
        }

        var ret = "";
        let days = parseInt(Math.floor(value / (3600 * 24)));
        let hours = parseInt(Math.floor((value - days * (3600 * 24)) / 3600));
        let minutes = parseInt(Math.floor((value - days * (3600 * 24) - hours * 3600) / 60));
        let seconds = parseInt((value - (hours * 3600 + minutes * 60)) % 60);

        if (!days && !hours && !minutes && !seconds) {
            return "0s";
        } else {
            if (seconds) {
                ret = seconds + "s";
            }
            if (minutes) {
                ret = minutes + "m " + ret;
            }
            if (hours) {
                ret = hours + "h " + ret;
            }
            if (days) {
                ret = days + "d " + ret;
            }
            return ret;
        }
    },
};

for (var f in Filters) {
    Vue.filter(f, Filters[f])
}
