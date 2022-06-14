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
-- Use case: analysis and troubleshooting
-- Usage:
-- List the average amount of data (in kilobytes) that is passing through
-- the Cloud Run services in request/response pairs.

SELECT http_request.request_url,
    (
        avg(http_request.request_size) / 1000.0 + avg(http_request.response_size) / 1000.0
    ) as pass_through_kilobytes
FROM `[MY_DATASET_ID]._AllLogs`
WHERE resource.type = "cloud_run_revision"
GROUP BY http_request.request_url;