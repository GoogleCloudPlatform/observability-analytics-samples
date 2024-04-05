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
-- Query the audit log to view the queries that completed 

SELECT
 timestamp,
 resource.labels.project_id,
 proto_payload.audit_log.authentication_info.principal_email,
 JSON_VALUE(proto_payload.audit_log.service_data.jobCompletedEvent.job.jobConfiguration.query.query) AS query,
 JSON_VALUE(proto_payload.audit_log.service_data.jobCompletedEvent.job.jobConfiguration.query.statementType) AS statementType,
 JSON_VALUE(proto_payload.audit_log.service_data.jobCompletedEvent.job.jobStatus.error.message) AS message,
 JSON_VALUE(proto_payload.audit_log.service_data.jobCompletedEvent.job.jobStatistics.startTime) AS startTime,
 JSON_VALUE(proto_payload.audit_log.service_data.jobCompletedEvent.job.jobStatistics.endTime) AS endTime,
 CAST(TIMESTAMP_DIFF( CAST(JSON_VALUE(proto_payload.audit_log.service_data.jobCompletedEvent.job.jobStatistics.endTime) AS TIMESTAMP), CAST(JSON_VALUE(proto_payload.audit_log.service_data.jobCompletedEvent.job.jobStatistics.startTime) AS TIMESTAMP), MILLISECOND)/1000 AS INT64) AS run_seconds,
 CAST(JSON_VALUE(proto_payload.audit_log.service_data.jobCompletedEvent.job.jobStatistics.totalProcessedBytes) AS INT64) AS totalProcessedBytes,
 CAST(JSON_VALUE(proto_payload.audit_log.service_data.jobCompletedEvent.job.jobStatistics.totalSlotMs) AS INT64) AS totalSlotMs,
 JSON_VALUE(proto_payload.audit_log.service_data.jobCompletedEvent.job.jobStatistics.referencedTables) AS tables_ref,
 CAST(JSON_VALUE(proto_payload.audit_log.service_data.jobCompletedEvent.job.jobStatistics.totalTablesProcessed) AS INT64) AS totalTablesProcessed,
 CAST(JSON_VALUE(proto_payload.audit_log.service_data.jobCompletedEvent.job.jobStatistics.queryOutputRowCount) AS INT64) AS queryOutputRowCount,
 severity
FROM
 `[MY_PROJECT_ID].global._Default._Default`
WHERE
 log_id = "cloudaudit.googleapis.com/data_access"
 AND proto_payload.audit_log.service_data.jobCompletedEvent IS NOT NULL
ORDER BY
 startTime

