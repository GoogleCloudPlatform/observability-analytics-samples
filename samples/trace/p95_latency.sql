/*
 * Copyright 2023 Google LLC
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
 
-- Use case: Extracts P95 latency

SELECT
  start_time AS start_time,
  STRING(attributes['rpc.service']) || '/' || STRING(attributes['rpc.method']) AS rpc_service_method,
  duration_nanos / 1000000 as duration_millis
FROM
  YOUR_PROJECT_NAME.global._Trace._AllSpans
WHERE
  kind.name = "SPAN_KIND_SERVER"
