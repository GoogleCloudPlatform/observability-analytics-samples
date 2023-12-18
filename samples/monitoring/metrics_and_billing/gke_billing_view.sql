CREATE OR REPLACE VIEW
  `[project_id].[dataset].gke_billing_view` AS
SELECT
  resource.global_name,
  ANY_VALUE(REGEXP_REPLACE(resource.name, '.+/', '')) AS resource_name,
  usage_start_time,
  project.id AS project_id,
  ancestors.resource_name AS pid,
  cluster.value AS cluster_name,
  namespace.value AS k8s_namespace,
  ANY_VALUE(labels) AS billing_labels,
  ANY_VALUE(tags) AS billing_tags,
  ANY_VALUE(system_labels) AS system_labels,
  ANY_VALUE(project.labels) AS project_labels,
  ANY_VALUE(project.ancestors) AS project_ancestors,
  sku.id AS sku_id,
  sku.description AS sku_description,
  SUM(cost) AS cost
FROM
  `[project_name].gcp_billing_export_resource_v1_<BILLING_ACCOUNT_ID>`,
  UNNEST(project.ancestors) AS ancestors
JOIN
  UNNEST(labels) AS CLUSTER
ON
  cluster.key = "goog-k8s-cluster-name"
LEFT JOIN
  UNNEST(labels) AS namespace
ON
  namespace.key = "k8s-namespace"
WHERE
  usage_start_time > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 31 DAY)
  AND ancestors.resource_name LIKE 'projects/%'
GROUP BY
  resource.global_name,
  usage_start_time,
  resource.name,
  cluster_name,
  k8s_namespace,
  project_id,
  sku_description,
  sku_id,
  pid