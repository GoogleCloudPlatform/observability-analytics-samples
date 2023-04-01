/*
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

-- Prerequisite: Logging is enabled for HTTP(S) load balancing
--   https://cloud.google.com/load-balancing/docs/https/https-logging-monitoring#logging
-- Use case: identify potential target traffic imbalances
-- Usage:
-- List all targets that the Load Balancer is routing traffic to and how many times
-- the Load Balancer has routed requests to each target, by percentage distribution.

SELECT http_request.server_ip as target_ip,
    (
        count(http_request.server_ip) * 100 / (
            select count(*)
            From `[MY_DATASET_ID]._AllLogs`
            WHERE resource.type = "http_load_balancer"
                AND http_request.server_ip != ''
        )
    ) as backend_traffic_percentage
FROM `[MY_PROJECT].global._Default._Default`
WHERE resource.type = "http_load_balancer"
GROUP BY target_ip
ORDER BY backend_traffic_percentage DESC
