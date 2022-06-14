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

-- Prerequisite: Deployed the microservice demo app on GKE
--   https://github.com/GoogleCloudPlatform/microservices-demo
-- Use case: analysis and troubleshooting
-- Usage:
-- Last 50 Kubernetes log entries with completed requests for the service 'frontend'

SELECT timestamp,
    log_name,
    severity,
    json_payload,
    resource,
    labels
FROM `[MY_DATASET_ID]._AllLogs`
WHERE timestamp > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 HOUR)
    AND json_payload IS NOT NULL
    AND json_payload.message IS NOT NULL
    AND JSON_VALUE(json_payload.message) = "request complete"
    AND JSON_VALUE(resource.labels.pod_name) LIKE "frontend%"
ORDER BY timestamp ASC
LIMIT 50