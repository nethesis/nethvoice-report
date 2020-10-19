package methods

import (
	"fmt"
	"math"
	"strings"
	"time"

	"github.com/ziutek/rrd"
)

/* Parameters
field - valid values are "calls" or "agents"
queue - queue number, eg 403
*/
func QueryQueueRRD(path string, field string, queue string, start time.Time, end time.Time) [][]interface{} { ////
	var dbfile string
	dbfile = fmt.Sprintf("%s/asterisk-queue_%s_%s/gauge-%s.rrd", path, field, queue, strings.Title(field))
	return fetchRRD(dbfile, start, end)
}

func QueryTotalCallsRRD(path string, start time.Time, end time.Time) [][]interface{} { ////
	var dbfile string
	dbfile = fmt.Sprintf("%s/asterisk-calls_total/gauge-Calls.rrd", path)
	return fetchRRD(dbfile, start, end)
}

func fetchRRD(dbfile string, start time.Time, end time.Time) [][]interface{} {
	var data [][]interface{}

	fetchRes, err := rrd.Fetch(dbfile, "AVERAGE", start, end, time.Second)
	if err != nil {
		return data
	}
	defer fetchRes.FreeValues()

	var columns []string
	columns = append(columns, "timestamp")
	for _, dsName := range fetchRes.DsNames {
		columns = append(columns, dsName)
	}

	var tmp []interface{}
	for _, c := range columns {
		tmp = append(tmp, c)
	}
	data = append(data, tmp)

	row := 0
	for ti := fetchRes.Start.Add(fetchRes.Step); ti.Before(end) || ti.Equal(end); ti = ti.Add(fetchRes.Step) {
		var record []interface{}
		record = append(record, int(ti.Unix()))
		for i := 0; i < len(fetchRes.DsNames); i++ {
			v := fetchRes.ValueAt(i, row)
			value := int(math.Round(v))

			if value < 0 {
				value = 0
			}
			record = append(record, value)
		}
		row++
		data = append(data, record)
	}

	return data
}
