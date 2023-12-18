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
-- Use case: analyze traffic distribution and patterns
-- Usage:
-- List clients in descending order, by the amount of data (in megabytes)
-- that each client received in their responses from the Cloud Run services.

SELECT http_request.remote_ip as client_ip,
    sum(http_request.response_size / 1000000) as client_data_received_megabytes
FROM `[MY_PROJECT].global._Default._Default`
WHERE resource.type = "cloud_run_revision"
    AND http_request.remote_ip is not null
GROUP by client_ip
ORDER by client_data_received_megabytes DESC;
