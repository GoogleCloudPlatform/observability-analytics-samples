/* Copyright 2024 Google LLC
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 https://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */
 
-- Logs from STDOUT across the TPU nodes 
SELECT
 timestamp,
 severity,
 resource.type,
 log_id,
 text_payload,
 proto_payload,
 json_payload
FROM
 `[MY_PROJECT].global._Default._Default`
WHERE
 resource.type="k8s_container"
 AND log_id="stdout"
 AND JSON_VALUE(labels['compute.googleapis.com/resource_name']) LIKE '[TPU_NODE_PREFIX]%'
LIMIT
 1000

