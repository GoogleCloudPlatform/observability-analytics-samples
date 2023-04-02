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
-- Use case: analysis and troubleshooting
-- Usage: 
-- List all client IP addresses that accessed the HTTP Load Balancer, 
-- and how many times they accessed the Load Balancer.

SELECT distinct(http_request.remote_ip),
    count(*) as num
FROM `[MY_PROJECT].global._Default._Default`
WHERE resource.type = "http_load_balancer"
GROUP BY http_request.remote_ip
LIMIT 50
