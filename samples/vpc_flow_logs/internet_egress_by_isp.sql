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
 
-- Select all external traffic from VPC to and split by geographic location
SELECT
 JSON_VALUE(json_payload.dest_location.asn) as asn,
 SUM(CAST(JSON_VALUE(json_payload.bytes_sent) as INT64)) as total_bytes_sent,
 SUM(CAST(JSON_VALUE(json_payload.packets_sent) as INT64)) as total_packets_sent,
 AVG(CAST(JSON_VALUE(json_payload.rtt_msec) as INT64)) as avg_rtt_msec,
 STDDEV(CAST(JSON_VALUE(json_payload.rtt_msec) as INT64)) as stddev_rtt_msec,
 COUNT(*) as log_count
FROM
 `[MY_PROJECT].global._Default._Default`
WHERE
 log_name LIKE "%compute.googleapis.com%2Fvpc_flows%"
 AND timestamp(replace(substr(JSON_VALUE(json_payload.start_time),0,19),"T"," ")) > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 HOUR)
 AND JSON_VALUE(json_payload.reporter) = "SRC"
 AND JSON_VALUE(json_payload.dest_location.asn) is not null
GROUP BY 1
ORDER BY 2 DESC
