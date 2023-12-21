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
-- List the top 10 destination IP by total bytes and packets to/from Kubernetes clusters.

SELECT JSON_VALUE(json_payload.connection.dest_ip) AS dest_ip,
    SUM(
        CAST(JSON_VALUE(json_Payload.packets_sent) AS INT64)
    ) AS packets_sent,
    SUM(
        CAST(JSON_VALUE(json_Payload.bytes_sent) AS INT64)
    ) AS bytes_sent
FROM `[MY_PROJECT].global._Default._Default`
WHERE   resource.type = "gce_subnetwork"
    AND log_id = "compute.googleapis.com/vpc_flows"
    AND JSON_VALUE(
        json_Payload.src_gke_details.cluster.cluster_name
    ) IS NOT NULL
GROUP BY 1
ORDER BY 3 DESC,
    2 DESC,
    1
LIMIT 10
