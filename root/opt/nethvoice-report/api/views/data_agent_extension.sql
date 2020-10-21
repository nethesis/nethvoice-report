DROP TABLE IF EXISTS agent_extensions;

CREATE TABLE agent_extensions AS
  SELECT DISTINCT extension, name
  FROM   asterisk.users
  WHERE  name IN (SELECT DISTINCT agent
                  FROM   asteriskcdrdb.report_queue
                  WHERE  agent != 'NONE');
