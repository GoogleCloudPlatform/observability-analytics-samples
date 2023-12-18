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

-- Prerequisite: For Cloud Run or Cloud Function V2 HTTP services
-- Use case: analyze incoming traffic distribution
-- Usage:
-- Count the number of HTTP GET requests
-- received by the load balancer grouped by the client IP address.

SELECT COUNT(http_request.request_method) AS count,
    http_request.request_method,
    http_request.remote_ip
FROM `[MY_PROJECT].global._Default._Default`
WHERE resource.type = "cloud_run_revision"
    AND http_request.request_method = 'GET'
GROUP BY http_request.request_method,
    http_request.remote_ip
ORDER BY count DESC;
