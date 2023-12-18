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
 
-- Use case: Extracts commonly used information from spans without any aggregation functions

SELECT
  start_time,
  COALESCE(
    JSON_VALUE(resource.attributes, '$."service.name"'),
    JSON_VALUE(attributes, '$."g.co/gae/app/module"')) AS service_name,
  name AS span_name,
  end_time_unix_nanos - start_time_unix_nanos AS duration_nanos,
  status.code.name AS status,
  trace_id,
  span_id
FROM
  YOUR_PROJECT_NAME.global._Trace._AllSpans
