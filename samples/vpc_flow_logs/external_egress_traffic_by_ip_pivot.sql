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
 
WITH networking_base AS (
SELECT
 TIMESTAMP_TRUNC(timestamp, HOUR) as datehour,
 JSON_VALUE(json_payload.src_instance.region) as region,
 "EGRESS" as traffic_type,
 ROUND(SUM(CAST(JSON_VALUE(json_payload.bytes_sent) as INT64))/(1024^3)) as total_gibbytes_sent,
 SUM(CAST(JSON_VALUE(json_payload.packets_sent) as INT64)) as total_packets_sent
FROM
`[MY_PROJECT].global._Default._Default`
WHERE
 log_id = "compute.googleapis.com/vpc_flows"
 AND (JSON_VALUE(json_payload.src_vpc.vpc_name) is null or JSON_VALUE(json_payload.dest_vpc.vpc_name) is null)
 AND SEARCH(json_payload.reporter, "SRC")
GROUP BY 1,2
) 

select * FROM (
   SELECT datehour, region, total_gibbytes_sent  from networking_base 
) PIVOT (

  SUM(total_gibbytes_sent) as total_gibbytes_sent
  FOR region IN (
    'asia-east1',
    'asia-east2',
    'asia-northeast1',
    'asia-northeast2',
    'asia-northeast3',
    'asia-south1',
    'asia-south2',
    'asia-southeast1',
    'asia-southeast2',
    'australia-southeast1',
    'australia-southeast2',
    'europe-central2',
    'europe-north1',
    'europe-southwest1',
    'europe-west1',
    'europe-west12',
    'europe-west2',
    'europe-west3',
    'europe-west4',
    'europe-west6',
    'europe-west8',
    'europe-west9',
    'me-central1',
    'me-west1',
    'northamerica-northeast1',
    'northamerica-northeast2',
    'southamerica-east1',
    'southamerica-west1',
    'us-central1',
    'us-central2',
    'us-east1',
    'us-east4',
    'us-east5',
    'us-east7',
    'us-south1',
    'us-west1',
    'us-west2',
    'us-west3',
    'us-west4')
)
ORDER BY 1 DESC 
