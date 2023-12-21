/* Copyright 2022 Google LLC
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 https://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */
-- Prerequisite: You need to enable VPC flow logs. 
--   https://cloud.google.com/vpc/docs/using-flow-logs#enabling-vpc-flow-logs
-- Use case: network analysis and troubleshooting
-- Usage:
-- Get the total bytes and packets by protocol over the past day.

CREATE TEMP FUNCTION PORTS_TO_PROTO(src_port INT64, dst_port INT64) AS (
    CASE
        WHEN src_port = 22
        OR dst_port = 22 THEN 'ssh'
        WHEN src_port = 80
        OR dst_port = 80 THEN 'http'
        WHEN src_port = 443
        OR dst_port = 443 THEN 'https'
        WHEN src_port = 10402
        OR dst_port = 10402 THEN 'gae' -- App Engine flexible environment
        WHEN src_port = 8443
        OR dst_port = 8443 THEN 'gae' -- App Engine flexible environment
        ELSE FORMAT('other-%d->%d', src_port, dst_port)
    END
);
SELECT DATE_TRUNC(
        PARSE_DATE(
            '%F',
            SPLIT(JSON_VALUE(json_payload.start_time), 'T') [
    OFFSET
      (0)]
        ),
        DAY
    ) AS time_period,
    PORTS_TO_PROTO(
        CAST(
            JSON_VALUE(json_payload.CONNECTION.src_port) AS INT64
        ),
        CAST(
            JSON_VALUE(json_payload.CONNECTION.dest_port) AS INT64
        )
    ) AS protocol,
    SUM(
        CAST(JSON_VALUE(json_payload.bytes_sent) AS int64)
    ) AS bytes,
    SUM(
        CAST(JSON_VALUE(json_payload.packets_sent) AS int64)
    ) AS packets,
    JSON_VALUE(json_payload.src_instance.project_id) AS src_project_id
FROM `[MY_PROJECT].global._Default._Default`
GROUP BY time_period,
    protocol,
    src_project_id
ORDER BY packets DESC,
    time_period DESC
