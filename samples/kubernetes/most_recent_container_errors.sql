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

-- Use case: analysis and troubleshooting
-- Usage:
-- List 50 most recent container errors from Kubernetes.

SELECT TIMESTAMP,
  JSON_VALUE(resource.labels.container_name) AS container,
  json_payload,
  FROM `[MY_PROJECT].global._Default._Default`
WHERE severity = "ERROR"
ORDER BY 1 DESC
LIMIT 50
