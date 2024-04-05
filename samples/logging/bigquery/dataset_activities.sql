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
-- Query the audit log to view 
-- the activities that dataset are created or deleted

SELECT
 timestamp,
 severity,
 resource.type,
 proto_payload.audit_log.authentication_info.principal_email,
 proto_payload.audit_log.method_name,
 proto_payload.audit_log.resource_name,
FROM
 `[MY_PROJECT_ID].global._Required._AllLogs`
WHERE
 log_id = 'cloudaudit.googleapis.com/activity'
 AND proto_payload.audit_log.method_name LIKE 'datasetservice%'
LIMIT
 100

