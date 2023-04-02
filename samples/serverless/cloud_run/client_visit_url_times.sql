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
-- Use case: analyze traffic patterns
-- Usage:
-- List clients in descending order, by the number of times that
-- each client visited a specified URL.

SELECT JSON_VALUE(resource.labels.service_name) as name,
    http_request.remote_ip as client_ip,
    http_request.request_url as request_url,
    count(*) as count
FROM `[MY_PROJECT].global._Default._Default`
WHERE resource.type = "cloud_run_revision"
GROUP by 1,
    2,
    3
ORDER by count DESC;
