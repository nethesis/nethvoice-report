#!/usr/bin/php
<?php
/*
 * This scripts consolidates queue statistics
 */

# Test lock
$fp = fopen( "/var/run/nethvoice/queuereport-update-lock", "a" );
if ( !$fp || !flock($fp,LOCK_EX|LOCK_NB,$eWouldBlock) || $eWouldBlock ) {
  fputs( STDERR, "Failed to acquire lock!\n" );
  exit(1);
}

# Read and set timezone
$timezone = "Europe/Rome";
$config_file = "/var/lib/tancredi/data/scopes/defaults.ini";
if (file_exists($config_file)) {
    $sections = parse_ini_file("/var/lib/tancredi/data/scopes/defaults.ini", true);

    if (isset($sections['data']['timezone'])) {
        $timezone = $sections['data']['timezone'];
    }
}
ini_set("date.timezone", $timezone);
$now = time();


# Connect to db
$conf = json_decode(file_get_contents("/opt/nethvoice-report/api/conf.json"), true);
if (!$conf) {
    fputs(STDERR, "Can't read configuration file");
    exit(1);
}
$conf = $conf['queue_database'];

try {
    $cdrdb = new PDO("mysql:dbname={$conf['name']};host={$conf['host']}", $conf['user'], $conf['password']);
} catch  (PDOException $e) {
    fputs(STDERR, 'Connection failed: ' . $e->getMessage());
    exit(1);
}


# Copy queue_log content into queue_log_history
$sqls = array();
$sqls[] = "INSERT IGNORE INTO queue_log_history (time,callid,queuename,agent,event,data,data1,data2,data3,data4,data5) SELECT time,callid,queuename,agent,event,data,data1,data2,data3,data4,data5 FROM queue_log WHERE UNIX_TIMESTAMP(time) < ?";

# Delete queue_log
$sqls[] = "DELETE FROM queue_log WHERE UNIX_TIMESTAMP(time) < ?";

if (!empty($sqls)) {
    foreach ($sqls as $sql) {
        try {
           $stmt = $cdrdb->prepare($sql);
           $stmt->execute([$now]);
           $cdrdb->query($sql);
        } catch (Exception $e) {
            error_log($e->getMessage());
        }
    }
}
// get last saved time as start_ts
$last_saved_ts = get_newer_saved();
// Do not more than last week. Older will be eventualy made backward day by day
if ($last_saved_ts < ($now - 7 * 24 * 60 * 60)) {
    $start_ts = ($now - 7 * 24 * 60 * 60);
} else {
    $start_ts = $last_saved_ts;
}
$end_ts = $now;

# Execute queries
do_time_queries($start_ts,$end_ts);

// save older log reports backward if it is needed
$first_queue_log_history_ts = get_older_in_history();

if ($first_queue_log_history_ts != FALSE) {
    $older = get_older_saved();
    while ($first_queue_log_history_ts < $older) {
        $end_ts = $older;
        if ($first_queue_log_history_ts < $older - 86400) {
            $start_ts = $older - 86400;
        } else {
            $start_ts = $first_queue_log_history_ts;
        }
        do_time_queries($start_ts,$end_ts);
        $older = $older - 86400;
    }
}
do_static_queries();

# Release lock
fclose( $fp );
unlink( "/var/run/nethvoice/queuereport-update-lock" );

# get older saved timestamp #
function get_older_saved() {
    // find empty older rows
    global $cdrdb;
    global $now;
    # Get first saved timestamp #
    $sql = "SELECT `timestamp_out` FROM `report_queue` ORDER BY `timestamp_out` ASC LIMIT 1";
    $stmt = $cdrdb->prepare($sql);
    $stmt->execute();
    $results = $stmt->fetchAll(\PDO::FETCH_ASSOC);
    if (isset($results[0]['timestamp_out'])) {
        return $results[0]['timestamp_out'];
    }
    return $now;
}

# Get newer saved timestamp #
function get_newer_saved() {
    global $cdrdb;
    $sql = "SELECT `timestamp_out` FROM `report_queue` ORDER BY `timestamp_out` DESC LIMIT 1";
    $stmt = $cdrdb->prepare($sql);
    $stmt->execute();
    $results = $stmt->fetchAll(\PDO::FETCH_ASSOC);
    if (isset($results[0]['timestamp_out'])) {
        return $results[0]['timestamp_out'];
    }
    return 0;
}

# Get older timestamp in queue_log_history
function get_older_in_history() {
    global $cdrdb;
    $sql = "SELECT UNIX_TIMESTAMP(time) as timestamp_out FROM queue_log_history a inner join asterisk.queues_config qc on queuename=qc.extension where event in ('ABANDON','EXITWITHTIMEOUT','EXITWITHKEY','EXITEMPTY','FULL','JOINEMPTY', 'COMPLETEAGENT','COMPLETECALLER') ORDER BY time ASC LIMIT 1";
    $stmt = $cdrdb->prepare($sql);
    $stmt->execute();
    $results = $stmt->fetchAll(\PDO::FETCH_ASSOC);
    if (isset($results[0]['timestamp_out'])) {
        return $results[0]['timestamp_out'];
    }
    return false;
}

function do_time_queries($start_ts,$end_ts) {
    global $cdrdb;
    $sqls = array();

    $sqls[] = "INSERT INTO report_queue ( id,timestamp_out,timestamp_in,qname,action,position,duration,hold,data4,agent,qdescr)
    select id,UNIX_TIMESTAMP(time) as timestamp_out, callid as timestamp_in, queuename as qname,
         event as action,
         cast(data1 as UNSIGNED) as position,
         cast(data2 as UNSIGNED) as duration,
         cast(data3 as UNSIGNED) as hold,
         cast(data4 as UNSIGNED) as data4,
         agent,qc.descr as qdescr
       from queue_log_history a inner join asterisk.queues_config qc on queuename=qc.extension
       where event in ('ABANDON','EXITWITHTIMEOUT','EXITWITHKEY','EXITEMPTY','FULL','JOINEMPTY') AND UNIX_TIMESTAMP(time) > $start_ts AND UNIX_TIMESTAMP(time) < $end_ts
       UNION ALL
       select id,UNIX_TIMESTAMP(time) as timestamp_out, callid as timestamp_in, queuename as qname,
         'ANSWER' as action,
         cast(data3 as UNSIGNED) as position,
         cast(data2 as UNSIGNED) as duration,
         cast(data1 as UNSIGNED) as hold,
         cast(data4 as UNSIGNED) as data4,
         agent,qc.descr as qdescr
       from queue_log_history a inner join asterisk.queues_config qc on queuename=qc.extension
       where event in ('COMPLETEAGENT','COMPLETECALLER') AND UNIX_TIMESTAMP(time) > $start_ts AND UNIX_TIMESTAMP(time) < $end_ts";

    $sqls[] = "INSERT INTO report_queue_agents ( id,timestamp_out,timestamp_in,qname,action,position,duration,hold,agent,qdescr)
       select id,UNIX_TIMESTAMP(time) as timestamp_out, callid as timestamp_in, queuename as qname,
         event as action,
         cast(data3 as UNSIGNED) as position,
         cast(data2 as UNSIGNED) as duration,
         round(cast(data1 as UNSIGNED) / 1000) as hold,
         agent,qc.descr as qdescr
       from queue_log_history a inner join asterisk.queues_config qc on queuename=qc.extension
       where event in ('RINGNOANSWER') AND UNIX_TIMESTAMP(time) > $start_ts AND UNIX_TIMESTAMP(time) < $end_ts
       UNION ALL
       select id,UNIX_TIMESTAMP(time) as timestamp_out, callid as timestamp_in, queuename as qname,
         'ANSWER' as action,
         cast(data3 as UNSIGNED) as position,
         cast(data2 as UNSIGNED) as duration,
         cast(data1 as UNSIGNED) as hold,
         agent,qc.descr as qdescr
       from queue_log_history a inner join asterisk.queues_config qc on queuename=qc.extension
       where event in ('COMPLETEAGENT','COMPLETECALLER') AND UNIX_TIMESTAMP(time) > $start_ts AND UNIX_TIMESTAMP(time) < $end_ts";


    $sqls[] = "INSERT INTO report_queue_callers ( id,timestamp_out,timestamp_in,qname,cid,action,position,qdescr,prefisso,comune,siglaprov,provincia,regione)
       select id,UNIX_TIMESTAMP(time) as timestamp_out, callid as timestamp_in, queuename as qname, data2 as cid, event as action, data3 as position, qc.descr as qdescr, prefisso, comune, siglaprov, provincia, regione
       from queue_log_history a inner join asterisk.queues_config qc on queuename=qc.extension left join zone z on (INSTR(data2, prefisso) = 1)
       where event = 'ENTERQUEUE' AND UNIX_TIMESTAMP(time) > $start_ts AND UNIX_TIMESTAMP(time) < $end_ts";

    $sqls[] = "INSERT INTO report_queue_callers ( id,timestamp_out,timestamp_in,qname,cid,action,position,qdescr,prefisso,comune,siglaprov,provincia,regione)
       select id,UNIX_TIMESTAMP(time) as timestamp_out, callid as timestamp_in, queuename as qname, data1 as cid, event as action, '0' as position, qc.descr as qdescr, prefisso, comune, siglaprov, provincia, regione
       from queue_log_history a inner join asterisk.queues_config qc on queuename=qc.extension left join zone z on (INSTR(data2, prefisso) = 1)
       where (event='FULL' or event='JOINEMPTY') AND UNIX_TIMESTAMP(time) > $start_ts AND UNIX_TIMESTAMP(time) < $end_ts";

    $sqls[] = "INSERT INTO agentsessions (qname,agent,action,timestamp_in,reason,timestamp_out,qdescr)
       select queuename,agent,'pause',unix_timestamp(time),data1,(select unix_timestamp(time) from queue_log_history d WHERE (event='UNPAUSE' OR event='AGENTLOGOFF' OR event='REMOVEMEMBER') and agent NOT LIKE 'Local/%@from-queue/n' and d.time>c.time and d.agent = c.agent and d.time<(c.time+86400) and d.queuename=c.queuename order by time limit 1), qc.descr
       from queue_log_history c inner join asterisk.queues_config qc on queuename=qc.extension
       WHERE event='PAUSE' and agent NOT LIKE 'Local/%@from-queue/n' AND UNIX_TIMESTAMP(time) > $start_ts AND UNIX_TIMESTAMP(time) < $end_ts";

    $sqls[] = "INSERT INTO agentsessions (qname,agent,action,timestamp_in,reason,timestamp_out,qdescr)
       select queuename,agent,'logon',unix_timestamp(time),data1,(select unix_timestamp(time) from queue_log_history d WHERE (event='REMOVEMEMBER' or event='AGENTLOGOFF') and agent NOT LIKE 'Local/%@from-queue/n' and d.time>c.time and d.agent = c.agent and d.time<(c.time+86400) and d.queuename=c.queuename order by time limit 1), qc.descr
       from queue_log_history c inner join asterisk.queues_config qc on queuename=qc.extension
       WHERE event='ADDMEMBER' and agent NOT LIKE 'Local/%@from-queue/n' AND UNIX_TIMESTAMP(time) > $start_ts AND UNIX_TIMESTAMP(time) < $end_ts";

    $sqls[] = "INSERT INTO agentsessions (qname,agent,action,timestamp_in,reason,timestamp_out,qdescr)
       select queuename,agent,'agent',unix_timestamp(time),data1,(select unix_timestamp(time) from queue_log_history d WHERE event='AGENTLOGOFF' and agent NOT LIKE 'Local/%@from-queue/n' and d.time>c.time and d.agent = c.agent and d.time<(c.time+86400) and d.queuename=c.queuename order by time limit 1), qc.descr
       from queue_log_history c inner join asterisk.queues_config qc on queuename=qc.extension
       WHERE event='AGENTLOGIN' and agent NOT LIKE 'Local/%@from-queue/n' AND UNIX_TIMESTAMP(time) > $start_ts AND UNIX_TIMESTAMP(time) < $end_ts";

    $sqls[] = "INSERT IGNORE INTO ivr_choice (select a.uniqueid,unix_timestamp(eventtime) as timestamp_in,a.cid_name,a.cid_num,a.context,b.name,a.exten from cel a inner join asterisk.ivr_details b on a.context=concat('ivr-',b.id) where eventtype='IVR_CHOICE' AND unix_timestamp(eventtime) > $start_ts AND UNIX_TIMESTAMP(eventtime) < $end_ts)";

    $sqls[] = "UPDATE report_queue SET cid = (SELECT cid FROM report_queue_callers WHERE report_queue_callers.timestamp_in = report_queue.timestamp_in LIMIT 1) WHERE cid IS NULL AND timestamp_in > $start_ts";

    foreach ($sqls as $sql) {
        try {
           $cdrdb->query($sql);
        } catch (Exception $e) {
           error_log($e->getMessage());
        }
    }
}

function do_static_queries() {
    global $cdrdb;
    $sqls = array();

    $sqls[] = "UPDATE agentsessions a SET timestamp_out = (select UNIX_TIMESTAMP(time) from queue_log_history d WHERE (event='UNPAUSE' OR event='AGENTLOGOFF' OR event='REMOVEMEMBER') and agent NOT LIKE 'Local/%@from-queue/n' and a.timestamp_in<UNIX_TIMESTAMP(d.time) and a.agent = d.agent and a.qname = d.queuename order by time limit 1) WHERE a.timestamp_out is NULL AND a.action='pause'";

$sqls[] = "UPDATE agentsessions a SET timestamp_out = (select UNIX_TIMESTAMP(time) from queue_log_history d WHERE (event='REMOVEMEMBER' or event='AGENTLOGOFF') and agent NOT LIKE 'Local/%@from-queue/n' and a.timestamp_in<UNIX_TIMESTAMP(d.time) and a.agent = d.agent and a.qname = d.queuename order by time limit 1) WHERE a.timestamp_out is NULL AND a.action='logon'";

$sqls[] = "UPDATE agentsessions a SET timestamp_out = (select UNIX_TIMESTAMP(time) from queue_log_history d WHERE event='AGENTLOGOFF' and agent NOT LIKE 'Local/%@from-queue/n' and a.timestamp_in<UNIX_TIMESTAMP(d.time) and a.agent = d.agent and a.qname = d.queuename order by time limit 1) WHERE a.timestamp_out is NULL AND a.action='agent'";

    foreach ($sqls as $sql) {
        try {
           $cdrdb->query($sql);
        } catch (Exception $e) {
           error_log($e->getMessage());
        }
    }

}

