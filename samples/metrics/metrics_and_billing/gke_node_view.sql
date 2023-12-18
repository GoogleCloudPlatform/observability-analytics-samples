CREATE OR REPLACE VIEW
`[project_id].[dataset].gke_node_view` AS
SELECT
 start_time,
 end_time,
 resource_project_id,
 resource_cluster_name,
 resource_location,
 SUM(node_allocatable_cores) as node_allocatable_cores,
 SUM(node_total_cores) as node_total_cores,
 AVG(node_allocatable_utilization) as node_allocatable_utilization
FROM (
 SELECT
   TIMESTAMP_TRUNC(start_time, HOUR) AS start_time,
   TIMESTAMP_TRUNC(end_time, HOUR) AS end_time,
   JSON_VALUE(resource.labels, '$.monitored_resource_container') AS resource_project_id,
   JSON_VALUE(resource.labels, '$.cluster_name') AS resource_cluster_name,
   JSON_VALUE(resource.labels, '$.location') AS resource_location,
   JSON_VALUE(resource.labels, '$.node_name') AS resource_node_name,
   CASE name
     WHEN 'kubernetes.io/node/cpu/allocatable_cores' THEN 'node_allocatable_cores'
     WHEN 'kubernetes.io/node/cpu/allocatable_utilization' THEN 'node_allocatable_utilization'
     WHEN 'kubernetes.io/node/cpu/total_cores' THEN 'node_total_cores'
 END
   AS name,
   AVG(value.double_value) AS value
 FROM
   `[project_name].[dataset]_Metrics._AllMetrics`
 WHERE
   resource.type = 'k8s_node'
   AND name IN ('kubernetes.io/node/cpu/allocatable_cores',
     'kubernetes.io/node/cpu/allocatable_utilization',
     'kubernetes.io/node/cpu/total_cores')
 GROUP BY
   1,2,3,4,5,6,7) PIVOT(SUM(value) FOR name IN ('node_allocatable_cores',
     'node_total_cores',
     'node_allocatable_utilization'))
GROUP BY 1,2,3,4,5
