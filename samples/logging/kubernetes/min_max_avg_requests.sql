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
-- Use case: log analysis and troubleshooting
-- Usage:
-- Get min, max, avg # of requests grouped by by hour for the frontend service.

SELECT hour,
    MIN(took_ms) as min,
    MAX(took_ms) AS max,
    AVG(took_ms) AS avg
FROM (
        SELECT FORMAT_TIMESTAMP("%H", timestamp) AS hour,
            CAST(
                JSON_VALUE(json_payload, '$."http.resp.took_ms"') AS INT64
            ) as took_ms
        FROM `[MY_PROJECT].global._Default._Default`
        WHERE json_payload IS NOT NULL
            AND SEARCH(labels, "frontend")
            AND SEARCH(json_payload.message,"`request complete`")
        ORDER BY took_ms DESC,
            timestamp ASC
    )
GROUP BY 1
ORDER BY 1
