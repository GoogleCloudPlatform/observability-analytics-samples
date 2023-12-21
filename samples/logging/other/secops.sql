/* Copyright 2022 Google LLC
 
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
 
-- Use case: SecOps 
-- Usage:
-- List all audit logs for the past hour.
SELECT timestamp,
  log_name,
  proto_payload,
  severity,
  resource.type,
  resource,
  labels
FROM `[MY_PROJECT].global._Default._AllLogs`
WHERE proto_payload IS NOT NULL
  AND log_name LIKE "%cloudaudit.googleapis.com%"
ORDER BY timestamp ASC
LIMIT 50;

-- Use case: SecOps 
-- Usage:
-- Get audit logs by the principal field and IP address 
-- which show the user that took the action in the audit log and from where.
SELECT proto_payload.audit_log.authentication_info.principal_email,
  proto_payload.audit_log.request_metadata.caller_ip,
  count(*) as cnt
FROM `[MY_PROJECT].global._Default._AllLogs`
WHERE proto_payload IS NOT NULL
  AND log_name LIKE "%cloudaudit.googleapis.com%"
  AND proto_payload.audit_log.authentication_info.principal_email = "xxxxxxx@developer.gserviceaccount.com"
GROUP BY 1,
  2
ORDER BY 3 DESC
LIMIT 50;

-- Use case: SecOps 
-- Usage: 
-- Find all the audit logs associated with a specific IP address across any field in the table. 
SELECT timestamp,
  log_name,
  proto_payload,
  severity,
  resource.type,
  resource,
  labels
FROM `[MY_PROJECT].global._Default._AllLogs` as t
WHERE proto_payload IS NOT NULL
  AND log_name LIKE "%cloudaudit.googleapis.com%"
  AND SEARCH(t, "34.122.94.173")
ORDER BY timestamp ASC
LIMIT 50 WITH source_of_ip_addresses AS (
    SELECT proto_payload.audit_log.request_metadata.caller_ip as ip,
      COUNT(*) c
    FROM `[MY_DATASET_ID]._AllLogs` t
    WHERE timestamp > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
      AND proto_payload IS NOT NULL
      AND log_name LIKE "%cloudaudit.googleapis.com%"
    GROUP BY 1
  )
SELECT country_name,
  SUM(c) c
FROM (
    SELECT ip,
      country_name,
      c
    FROM (
        SELECT *,
          NET.SAFE_IP_FROM_STRING(ip) & NET.IP_NET_MASK(4, mask) network_bin
        FROM source_of_ip_addresses,
          UNNEST(GENERATE_ARRAY(9, 32)) mask
        WHERE BYTE_LENGTH(NET.SAFE_IP_FROM_STRING(ip)) = 4
      )
      JOIN `fh-bigquery.geocode.201806_geolite2_city_ipv4_locs` USING (network_bin, mask)
  )
GROUP BY 1
ORDER BY 2 DESC;

-- Use case: SecOps
-- Usage: Get unusual activity by user
-- and get details of what was done (methodName) to what resource (resourceName) over an extended time,
say last 2 months:
SELECT timestamp,
  proto_payload.audit_log.authentication_info.principal_email,
  proto_payload.audit_log.method_name,
  proto_payload.audit_log.service_name,
  proto_payload.audit_log.resource_name,
  proto_payload.audit_log.request_metadata.caller_ip,
  FROM `[MY_PROJECT].global._Default._AllLogs`
WHERE  proto_payload.audit_log.request_metadata.caller_ip IS NOT NULL
ORDER BY timestamp DESC
LIMIT 1000;

-- Use case: SecOps 
-- Usage: 
/* 
 Using that list of cloud provisioning admin activities done over the last 2 months, we:
 (1) geolocate the IP address
 (2) group by activity tuples (action, actor, country) and identify the earliest instance this activity occurred
 (3) mark any activity tuple as new or unusual if the first instance of it was in the last week.
 */
SELECT IF(
    MIN(timestamp) >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY),
    1,
    0
  ) AS isUnusual,
  methodName,
  principalEmail,
  countryName,
  ARRAY_AGG(DISTINCT cityName IGNORE NULLS) AS cities,
  ARRAY_AGG(DISTINCT resourceName IGNORE NULLS) AS resources,
  MIN(timestamp) AS earliest,
  MAX(timestamp) AS latest,
  FROM(
    SELECT t.*,
      locs.country_name AS countryName,
      locs.city_name AS cityName
    FROM (
        SELECT *,
          NET.SAFE_IP_FROM_STRING(callerIp) & NET.IP_NET_MASK(4, mask) network_bin
        FROM actions,
          UNNEST(GENERATE_ARRAY(9, 32)) mask
        WHERE BYTE_LENGTH(NET.SAFE_IP_FROM_STRING(callerIp)) = 4
      ) AS t
      JOIN `fh-bigquery.geocode.201806_geolite2_city_ipv4_locs` AS locs USING (network_bin, mask)
  )
GROUP BY methodName,
  principalEmail,
  countryName
ORDER BY isUnusual DESC
