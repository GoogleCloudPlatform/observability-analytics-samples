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
-- Use case: troubleshoot latency in a specified time frame
-- Usage:
-- List each time in a specified date range when the
-- Cloud Run service latency was more than 2 seconds.

SELECT *
FROM `[MY_PROJECT].global._Default._Default`
WHERE resource.type = "cloud_run_revision"
    AND http_request.latency.nanos / 1000000000 > 2
    AND timestamp BETWEEN '2022-06-13T15:45:04' AND '2022-06-14T15:46:04'
limit 10
