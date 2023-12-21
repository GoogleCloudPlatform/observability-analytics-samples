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
-- Get the number of logs for the top producers of container
-- logs, grouped by cluster, location, pod_name and container_name.

SELECT JSON_VALUE(resource.labels.cluster_name) as cluster,
    JSON_VALUE(resource.labels.location) as location,
    JSON_VALUE(resource.labels.pod_name) as pod_name,
    JSON_VALUE(resource.labels.container_name) as container,
    count(*) as container_cnt
FROM `[MY_PROJECT].global._Default._Default`
WHERE resource.type = "k8s_container"
GROUP BY 1,
    2,
    3,
    4
ORDER BY 5 DESC
LIMIT 20
