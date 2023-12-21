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
-- Get the number of logs for the top producers of container logs,
-- LIMITED to error logs.

SELECT JSON_VALUE(resource.labels.container_name) as container,
    count(*) as container_cnt
FROM `[MY_PROJECT].global._Default._Default`
WHERE resource.type = "k8s_container"
    AND severity = "ERROR"
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10
