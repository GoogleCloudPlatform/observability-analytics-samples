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

-- Prerequisite: For Cloud Run or Cloud Function V2 HTTP services
-- Use case: analysis and troubleshooting
-- Usage: 
-- List top 50 requests with the longest latencies.

SELECT http_request.latency.nanos / 1000000 as latence_in_ms,
    log_name,
    severity,
    json_payload,
    resource,
    labels
FROM `[MY_DATASET_ID]._AllLogs`
WHERE resource.type = "cloud_run_revision"
    AND http_request IS NOT NULL
ORDER BY http_request.latency.nanos DESC
limit 50