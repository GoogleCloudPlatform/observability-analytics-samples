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
 
SELECT
 JSON_VALUE(json_payload.connection.src_ip) as local_ip,
 JSON_VALUE(json_payload.src_vpc.vpc_name) as vpc_name,
 JSON_VALUE(json_payload.src_instance.vm_name) as vm_name,
 JSON_VALUE(json_payload.connection.dest_ip) as external_ip,
 "EGRESS" as traffic_type,
SUM(CAST(JSON_VALUE(json_payload.bytes_sent) as INT64)) as total_bytes_sent
FROM
`[MY_PROJECT].global._Default._Default`
WHERE
log_id = "compute.googleapis.com/vpc_flows"
AND timestamp(replace(substr(JSON_VALUE(json_payload.start_time),0,19),"T"," ")) > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 HOUR)
AND (JSON_VALUE(json_payload.src_vpc.vpc_name) is null or JSON_VALUE(json_payload.dest_vpc.vpc_name) is null)
AND JSON_VALUE(json_payload.reporter) = "SRC"
GROUP BY 1,2,3,4
UNION ALL
SELECT
JSON_VALUE(json_payload.connection.dest_ip) as local_ip,
JSON_VALUE(json_payload.dest_vpc.vpc_name) as vpc_name,
JSON_VALUE(json_payload.dest_instance.vm_name) as vm_name,
JSON_VALUE(json_payload.connection.src_ip) as external_ip,
"INGRESS" as traffic_type,
SUM(CAST(JSON_VALUE(json_payload.bytes_sent) as INT64)) as total_bytes_sent
FROM
`[MY_PROJECT].global._Default._Default`
WHERE
log_id = "compute.googleapis.com/vpc_flows"
AND timestamp(replace(substr(JSON_VALUE(json_payload.start_time),0,19),"T"," ")) > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 HOUR)
AND (JSON_VALUE(json_payload.src_vpc.vpc_name) is null or JSON_VALUE(json_payload.dest_vpc.vpc_name) is null)
AND JSON_VALUE(json_payload.reporter) = "DEST"
GROUP BY 1,2,3,4
ORDER BY 6 DESC
