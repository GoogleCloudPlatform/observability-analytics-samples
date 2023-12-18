CREATE OR REPLACE VIEW
 `[project_id].[dataset].gke_cpu_view` AS
SELECT
 *,
 ARRAY(
 SELECT
   AS STRUCT "Utilized" AS type, request_cores*request_utilization AS cores
 UNION ALL
 SELECT
   AS STRUCT "Pod Idle" AS type, request_cores-(request_cores*request_utilization) AS cores
 UNION ALL
 SELECT
   AS STRUCT "Cluster Idle" AS type, node_allocatable_cores*(1-node_allocatable_utilization)
 AS cores
 UNION ALL
 SELECT
   AS STRUCT "Cluster Overhead" AS type, node_total_cores-node_allocatable_cores AS cores ) AS core_breakdown,
FROM
 `[project_id].[dataset].gke_node_view`
LEFT JOIN
 `[project_id].[dataset].gke_container_view`
USING
 (start_time,
   end_time,
   resource_project_id,
   resource_cluster_name)
INNER JOIN (
 SELECT
   usage_start_time,
   pid,
   cluster_name,
   ANY_VALUE(project_ancestors) AS project_ancestors,
   SUM(cost) AS net_cost
 FROM
   `[project_id].[dataset].gke_billing_view`
 WHERE
   cluster_name IS NOT NULL
   AND k8s_namespace IS NULL
 GROUP BY
   1,
   2,
   3 ) AS cluster_billing
ON
 cluster_billing.cluster_name=resource_cluster_name
 AND cluster_billing.usage_start_time = start_time
 AND cluster_billing.pid=resource_project_id