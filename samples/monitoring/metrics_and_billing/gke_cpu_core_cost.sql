CREATE OR REPLACE VIEW
 `[project_id].[dataset].gke_cpu_core_cost` AS
WITH
 request_cores AS (
 SELECT
   t,
   project_id,
   cluster_name,
   SUM(request_core) AS request_core
 FROM (
   SELECT
     TIMESTAMP_TRUNC(start_time, HOUR) AS t,
     JSON_VALUE(resource.labels, '$.monitored_resource_container') AS project_id,
     JSON_VALUE(resource.labels, '$.cluster_name') AS cluster_name,
     JSON_VALUE(resource.labels, '$.container_name') AS container_name,
     JSON_VALUE(resource.labels, '$.pod_name') AS pod_name,
     AVG(value.double_value) AS request_core,
   FROM
     `[project_name].[dataset]_Metrics._AllMetrics`
   WHERE
     resource.type = 'k8s_container'
     AND name ='kubernetes.io/container/cpu/request_cores'
   GROUP BY
     1,2,3,4,5)
 GROUP BY
   1,2,3),
 allocatable_cores AS (
 SELECT
   t,
   project_id,
   cluster_name,
   SUM(allocatable_core) AS allocatable_core
 FROM (
   SELECT
     TIMESTAMP_TRUNC(start_time, HOUR) AS t,
     JSON_VALUE(resource.labels, '$.monitored_resource_container') AS project_id,
     JSON_VALUE(resource.labels, '$.cluster_name') AS cluster_name,
     JSON_VALUE(resource.labels, '$.node_name') AS node_name,
     name,
     AVG(value.double_value) AS allocatable_core
   FROM
     `[project_name].[dataset]_Metrics._AllMetrics`
   WHERE
     resource.type = 'k8s_node'
     AND name = 'kubernetes.io/node/cpu/allocatable_cores'
   GROUP BY
     1,2,3,4,5)
 GROUP BY
   1,2,3),
 cost_table AS (
 SELECT
   TIMESTAMP_TRUNC(usage_start_time, HOUR) AS t,
   project_id,
   cluster_name,
   SUM(cost) AS cost,
 FROM
   `[project_id].[dataset].clean_billing_view`
 GROUP BY 1,2,3)
SELECT
 t,
 ct.project_id,
 ct.cluster_name,
 request_core,
 allocatable_core,
 (request_core/allocatable_core)*100 AS app_used_percentage,
 (1-request_core/allocatable_core)*100 AS waste_percentage,
 (request_core/allocatable_core)*cost AS used_cost,
 (1-request_core/allocatable_core)*cost AS waste_cost,
 cost AS total_cost
FROM
 request_cores
JOIN
 allocatable_cores
USING
 (t, project_id, cluster_name)
JOIN
 cost_table AS ct
USING
 (t, cluster_name)