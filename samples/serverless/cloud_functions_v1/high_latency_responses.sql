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
-- List top 10 Cloud Functions instances that used most of time
-- in a specified date range 

SELECT JSON_VALUE(resource.labels.function_name) as name,
    timestamp as exec_time,
    SPLIT(text_payload, ' ') [SAFE_OFFSET(3)] as time_in_ms
FROM `[MY_DATASET_ID]._AllLogs`
WHERE timestamp > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 DAY)
    AND log_name like '%cloud_functions'
    AND text_payload like '%took%'
ORDER BY time_in_ms DESC
LIMIT 10