## Cloud Logging Samples
| # | Query Sample | Log Source |
|---|---|---|
| <div id="login-access-patterns">1</div> | **Google Cloud Load Balancing**
| 1.1| [The average amount of data that is passing through](./gclb/https-lb-avg_data_pass_through.sql)|HTTP(S) LB Logs |
| 1.2| [All targets that the Load Balancer is routing traffic to and how many times](./gclb/https-lb-backend_traffic_percentage.sql)|HTTP(S) LB Logs |
| 1.3| [All client IP addresses that accessed the HTTP LB, and times they accessed the LB](./gclb/https-lb-client_ip_access_times.sql)|HTTP(S) LB Logs |
| 1.4| [List clients by the amount of data they received from the LB](./gclb/https-lb-client_receive_data.sql)|HTTP(S) LB Logs |
| 1.5| [List clients by the number of times that each client visited a specified URL](./gclb/https-lb-client_visit_url_times.sql)|HTTP(S) LB Logs |
| 1.6| [The LB latency was more than 2 seconds](./gclb/https-lb-high_latency_logs.sql)|HTTP(S) LB Logs |
| 1.7| [View the first top access log entries in chronological order](./gclb/https-lb-recent_log_entries.sql)|HTTP(S) LB Logs |
| 1.8| [Count the number of HTTP GET requests](./gclb/https-lb-requst_method_by_client.sql)|HTTP(S) LB Logs |
| 1.9| [List top requests that having error status](./gclb/https-lb-status_code_not_200.sql)|HTTP(S) LB Logs |
| 1.10| [List the top URLs that Firefox users accessed most frequently](./gclb/https-lb-user_agent_most_visited_urls.sql)|HTTP(S) LB Logs |
| <div id="iam-keys-secrets-changes">2</div> | **Kubernetes**
| 2.1| [Get min, max, avg # of requests grouped for a service](./kubernetes/min_max_avg_requests.sql)| Kubernetes Logs |
| 2.2| [List most recent container errors from Kubernetes](./kubernetes/most_recent_container_errors.sql)|Kubernetes Logs |
| 2.3| [Last Kubernetes log entries with completed requests for a service](./kubernetes/pod_hourly_requests.sql)|Kubernetes Logs |
| 2.4| [Get the number of logs for the top producers of container error logs](./kubernetes/top_error_log_producers.sql)|Kubernetes Logs |
| 2.5| [Get the number of logs for the top grouped producers of container logs](./kubernetes/top_log_producers_cluster_loc_name.sql)|Kubernetes Logs |
| 2.6| [Get the number of logs for the top producers of container logs](./kubernetes/top_log_producers_grouped.sql)|Kubernetes Logs |
| 2.7| [Get the number of logs for the top producers of container logs by namespace](./kubernetes/top_log_producers_namespace.sql)|Kubernetes Logs |
| 2.8| [Get the total bytes sent between 2 Kubernetes pods](./kubernetes/network_bytes_between_pods.sql)| VPC Flow Logs	|
| 2.9| [Get the total bytes and packets to/from Kubernetes clusters](./kubernetes/network_bytes_between_clusters.sql)| VPC Flow Logs	|
| 2.10| [Top destination IPs by total bytes and packets to/from Kubernetes clusters.](./kubernetes/network_top_ips_for_clusters.sql)| VPC Flow Logs	|
| 2.11| [Get the total bytes and packets by protocol over the past day](./kubernetes/network_traffic_by_protocol.sql)| VPC Flow Logs	|
| 2.12| [Get the count of logs by severity](./kubernetes/k8s_cnt_by_severity)| Kubernetes Logs	|
| 2.13| [Get the count of logs by k8s service and severity](./kubernetes/k8s_count_by_service_by_severity)| Kubernetes Logs	|
| <div id="cloud-provisioning-activity">3</div> | **Serverless**
| 3.1| [Recent functions run time and status code](./serverless/cloud_functions_v1/exectime_with_status.sql)| Cloud Functions V1 logs|
| 3.2| [Top Cloud Functions instances that used most of time in a specified date range](./serverless/cloud_functions_v1/high_latency_responses.sql)|Cloud Functions V1 logs|
| 3.3| [Top instances that having error status in the last 24 hours](./serverless/cloud_functions_v1/status_code_not_200.sql)|Cloud Run logs| 
| 3.4| [Average amount of data that is passing through the Cloud Run services](./serverless/cloud_run/avg_data_pass_through.sql)| Cloud Run logs|
| 3.5| [Client IP addresses that accessed the Cloud Run service](./serverless/cloud_run/client_ip_access_times.sql)|Cloud Run logs|
| 3.6| [List clients by the amount of data they received from the Cloud Run services](./serverless/cloud_run/client_receive_data.sql)| Cloud Run logs|
| 3.7| [List clients by the number of times they visited a specified URL](./serverless/cloud_run/client_visit_url_times.sql)| Cloud Run logs|
| 3.8| [Each time the Cloud Run service latency was more than 2 seconds](./serverless/cloud_run/high_latency_responses.sql)|Cloud Run logs|
| 3.9| [Count HTTP GET requests received by the LB grouped by the client IP address](./serverless/cloud_run/requst_method_by_client.sql)|Cloud Run logs|
| 3.10| [Top requests that having error status](./serverless/cloud_run/status_code_not_200.sql)| Cloud Run logs|
| 3.11| [Get the number of logs for the top producers of Clour Run error logs](./serverless/cloud_run/top_error_log_producers.sql)| Cloud Run logs|
| 3.11| [Get the number of logs for the top grouped producers of Cloud Run error logs](./serverless/cloud_run/top_log_producers_grouped.sql)| Cloud Run logs|
| 3.12| [Top requests with the longest latencies](./serverless/cloud_run/top_long_latency.sql)|Cloud Run logs|
| 3.13| [Top URLs that Chrome users accessed most frequently, in descending order](./serverless/cloud_run/user_agent_most_visited_urls.sql)|Cloud Run logs|
| <div id="cloud-provisioning-activity">4</div> | **Networking**
| 4.1| [External traffic by IP](./vpc_flow_logs/external_traffic_by_ip.sql)|VPC Flow logs|
| 4.2| [Internet egress by country](./vpc_flow_logs/internet_egress_by_country.sql)|VPC Flow logs|
| 4.3| [Internet egress by ISP](./vpc_flow_logs/internet_egress_by_isp.sql)|VPC Flow logs|
| 4.4| [Internet egress by geo](./vpc_flow_logs/internet_traffic_by_geo.sql)|VPC Flow logs|
| 4.5| [Top Talkers](./vpc_flow_logs/top_talkers.sql)|VPC Flow logs|
| 4.6| [Total egress by zone](./vpc_flow_logs/total_egress_between_zones.sql)|VPC Flow logs|
| 4.6| [VM to VM traffic](./vpc_flow_logs/vm_to_vm_traffic.sql)|VPC Flow logs|
| <div id="cloud-provisioning-activity">4</div> | **BigQuery**
| 5.1| [Dataset activities](./bigquery/dataset_activities.sql)|BigQuery logs|
| 5.2| [Table activities](./bigquery/table_activities.sql)|BigQuery logs|
| 5.3| [Expired tables](./bigquery/expired_tables.sql)|BigQuery logs|
| 5.4| [Most popular datasets](./bigquery/most_popular_datasets.sql)|BigQuery logs|
| 5.5| [Completed queries](./bigquery/queries_completed.sql)|BigQuery logs|

## Security analytics

You can find additional query examples for security analytics in the GitHub repo [Community Security Analytics (CSA)](https://github.com/GoogleCloudPlatform/security-analytics).
