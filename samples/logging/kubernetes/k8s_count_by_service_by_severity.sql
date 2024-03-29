/* Copyright 2023 Google LLC
 
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

-- Count of log entries by service broken down by severity
SELECT
 JSON_VALUE(labels['k8s-pod/app']) as service,
 COUNTIF(severity="ERROR") as err_cnt,
 COUNTIF(severity="INFO") info_cnt,
 COUNTIF(severity="DEBUG") debug_cnt,
 COUNTIF(severity="WARNING") warning_cnt,
 COUNT(*) as total_cnt
FROM
 `[MY_PROJECT].global._Default._Default`
WHERE
 resource.type="k8s_container"
 AND labels['k8s-pod/app'] IS NOT NULL
GROUP BY 1
ORDER BY 1 ASC
