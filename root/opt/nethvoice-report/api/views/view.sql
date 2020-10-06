CREATE OR REPLACE VIEW performace_evase AS SELECT DATE_FORMAT(from_unixtime(timestamp_in),"%Y") AS period , qname, COUNT(id) FROM report_queue WHERE action='ANSWER' GROUP BY period,qname;
