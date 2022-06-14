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
-- Get the total bytes sent between 2 Kubernetes pods

SELECT JSON_VALUE(json_payload.src_gke_details.pod.pod_name) AS src_pod,
    JSON_VALUE(json_payload.dest_gke_details.pod.pod_name) AS dest_pod,
    SUM(
        CAST(JSON_VALUE(json_payload.bytes_sent) AS INT64)
    ) AS total_bytes_sent
FROM `[MY_DATASET_ID]._AllLogs`
WHERE timestamp > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 HOUR)
    AND log_name LIKE "%compute.googleapis.com%2Fvpc_flows%"
    AND JSON_VALUE(json_payload.reporter) = "SRC"
    AND JSON_VALUE(json_payload.src_gke_details.pod.pod_name) IS NOT NULL
    AND JSON_VALUE(json_payload.dest_gke_details.pod.pod_name) IS NOT NULL
GROUP BY 1,
    2
ORDER BY 3 DESC
LIMIT 50