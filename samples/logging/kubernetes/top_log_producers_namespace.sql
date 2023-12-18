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

-- Use case: log analysis and troubleshooting
-- Usage:
-- Get the number of logs for the top producers of container logs by namespace.

SELECT JSON_VALUE(resource.labels.cluster_name) as cluster,
    JSON_VALUE(resource.labels.location) as location,
    JSON_VALUE(resource.labels.namespace_name) as namespace,
    count(*) as container_cnt
FROM `[MY_PROJECT].global._Default._Default`
WHERE timestamp > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 DAY)
    AND resource.type = "k8s_container"
GROUP BY 1,
    2,
    3
ORDER BY 4 DESC
LIMIT 20
