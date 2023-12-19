## View the metrics and pricing data in BigQuery

Go to the BigQuery page in the Google Cloud console and 
verify the data is visible in the *_AllMetrics* table and the detailed export billing  table. For the following steps, we will use GKE as an example and show you how to associate the billing data with the metric data.

First, create a `gke_metric_billing` dataset in your project and ensure the region matches the billing export dataset region. Then, run some queries In the query editor to create a few views as our data sources.

1) Use the query in [gke_billing_view.sql](./gke_billing_view.sql) to create a clean GKE billing view. Please replace the `project id` and `dataset` accordingly.

2) Use the query in [gke_container_view.sql](./gke_container_view.sql) to create an interim view for GKE containers. 

3) Use the query in [gke_node_view.sql](./gke_node_view.sql) to create an interim view for GKE nodes.

4) Use the query in [gke_cpu_view.sql](./gke_cpu_view.sql) to create the view for GKE CPU metrics.

5) Use the query in [gke_cpu_core_cost.sql](./gke_cpu_core_cost.sql) to create a view to estimate the waste and used cost based on CPU usage.


## Visualize data in Looker Studio

Looker Studio is a free, self-service business intelligence platform that lets you build and consume data visualizations, dashboards, and reports. With Looker Studio, you can connect to your data, create visualizations, and share your insights with others.
Use Looker Studio to visualize data in the BigQuery:

* Open the [Metric and pricing dashboard template](https://lookerstudio.google.com/reporting/e426208d-e31e-4910-ba30-c8425957568f/page/BLaAD/preview).
* Click Use __my own data__.
* Select your project.
* For Dataset, select `gke_metric_billing`.
* For Table, select `gke_cpu_view`.
* Click __Add__.
* Click __Add to Report__.
* Repeat the steps above to add `gke_cpu_core_cost`.