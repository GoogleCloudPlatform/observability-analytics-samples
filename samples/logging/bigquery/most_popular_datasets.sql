/*
 * Copyright 2024 Google LLC
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
 
-- Use case: analysis and troubleshooting
-- Usage:
-- This query shows coarse, per-dataset statistics
-- about table reads and table modifications.

SELECT
  REGEXP_EXTRACT(proto_payload.audit_log.resource_name, '^projects/[^/]+/datasets/([^/]+)/tables') AS datasetRef,
  COUNT(DISTINCT REGEXP_EXTRACT(proto_payload.audit_log.resource_name, '^projects/[^/]+/datasets/[^/]+/tables/(.*)$')) AS active_tables,
  COUNTIF(JSON_QUERY(proto_payload.audit_log.metadata, "$.tableDataRead") IS NOT NULL) AS dataReadEvents,
  COUNTIF(JSON_QUERY(proto_payload.audit_log.metadata, "$.tableDataChange") IS NOT NULL) AS dataChangeEvents
FROM
  `[MY_PROJECT_ID].global._Default._Default`
WHERE
  log_id = "cloudaudit.googleapis.com/data_access"
  AND (JSON_QUERY(proto_payload.audit_log.metadata, "$.tableDataRead") IS NOT NULL
    OR JSON_QUERY(proto_payload.audit_log.metadata, "$.tableDataChange") IS NOT NULL)
GROUP BY
  datasetRef
ORDER BY
  datasetRef

