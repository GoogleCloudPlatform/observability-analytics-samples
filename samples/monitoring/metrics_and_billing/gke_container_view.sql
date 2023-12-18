CREATE OR REPLACE VIEW
 `[project_id].[dataset].gke_container_view` AS
SELECT
 start_time,
 end_time,
 resource_project_id,
 resource_cluster_name,
 SUM(request_cores) AS request_cores,
 AVG(request_utilization) AS request_utilization
FROM (
 SELECT
   TIMESTAMP_TRUNC(start_time, HOUR) AS start_time,
   TIMESTAMP_TRUNC(end_time, HOUR) AS end_time,
   JSON_VALUE(resource.labels, '$.monitored_resource_container') AS resource_project_id,
   JSON_VALUE(resource.labels, '$.cluster_name') AS resource_cluster_name,
   JSON_VALUE(resource.labels, '$.container_name') AS resource_container_name,
   JSON_VALUE(resource.labels, '$.pod_name') AS resource_pod_name,
   ARRAY_REVERSE(SPLIT(name, '/'))[SAFE_OFFSET(0)] AS metric_name,
   AVG(value.double_value) AS metric_value,
 FROM
   `[project_name].[project_id]_Metrics._AllMetrics`
 WHERE
   resource.type = 'k8s_container'
   AND name IN ('kubernetes.io/container/cpu/request_cores',
     'kubernetes.io/container/cpu/request_utilization')
 GROUP BY
   1,2,3,4,5,6,7) PIVOT(SUM(metric_value) FOR metric_name IN ('request_cores',
     'request_utilization' ))
GROUP BY
 1,2,3,4
