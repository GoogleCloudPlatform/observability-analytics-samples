/* Copyright 2023 Google LLC
 
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
 
CREATE TEMP FUNCTION PORTS_TO_PROTO(protocol INT64, src_port INT64, dst_port INT64) AS (
CASE
  WHEN protocol = 1 THEN 'icmp'
  WHEN src_port = 22 OR dst_port = 22 THEN 'ssh'
  WHEN src_port = 80 OR dst_port = 80 THEN 'http'
  WHEN src_port = 8080 OR dst_port = 8080 THEN 'http'
  WHEN src_port = 443 OR dst_port = 443 THEN 'https'
  WHEN src_port = 53 OR dst_port = 53 THEN 'dns'
  WHEN src_port = 10402 OR dst_port = 10402 THEN 'gae' -- App Engine flexible environment
  WHEN src_port = 8443 OR dst_port = 8443 THEN 'gae' -- App Engine flexible environment
  ELSE FORMAT('other-%d->%d', src_port, dst_port)
END
);


SELECT
 PORTS_TO_PROTO(
   CAST(JSON_VALUE(json_payload.connection.protocol) as INT64),
   CAST(JSON_VALUE(json_payload.connection.src_port) as INT64),
   CAST(JSON_VALUE(json_payload.connection.dest_port) as INT64)) as port,
 SUM(CAST(JSON_VALUE(json_payload.bytes_sent) as INT64)) as total_bytes_sent
FROM
 `[MY_PROJECT].global._Default._Default`
WHERE
 log_id = "compute.googleapis.com/vpc_flows"
 AND JSON_VALUE(json_payload.reporter) = "SRC")
GROUP BY 1
ORDER BY 2 DESC
