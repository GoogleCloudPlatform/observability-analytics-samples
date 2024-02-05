Building an OTel stack using Ansible Playbooks.
-------------------------------------------

These playbooks require Ansible 1.2.

These playbooks are meant to be a reference and starter's guide to building
Ansible Playbooks. These playbooks were tested on Debian 12.x.

This OTel stack can be on a single node or multiple nodes. The inventory file
'hosts' defines the nodes in which the stacks should be configured.

        [backend_collectors]
        10.128.0.37
        10.128.0.38

        [nginx]
        10.128.0.36

        [app_servers]
        10.128.0.39
        10.128.0.43

Before you deploy the stack, ensure you follow the following steps to create a
service account and download the service account key file.

### Create a service account for authentication

Ensure you have the proper permissions and perform the following steps in Cloud Shell opened from the Cloud console. If your platform supports workload identity federation, strongly consider using it instead of service accounts for enhanced security and simplified management.

1) Create the user-managed service account:

```bash
export SA_NAME=otel-export-sa
export PROJECT_ID=[Your Project Id]

gcloud iam service-accounts create ${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com
```
 Note:

 `SA_NAME`: the name of the service account.

 `PROJECT_ID`: the Cloud Ops destination project ID.

2) Grant the the following roles to the service account:

```bash    
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
--member=serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com \
--role=roles/monitoring.metricWriter

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
--member=serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com \
--role=roles/cloudtrace.agent

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
--member=serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com \
--role=roles/logging.logWriter
```

3) Download the service account key file

```bash
gcloud iam service-accounts keys create otel-sa-key.json \
--iam-account=${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com
```

Note: Keep the key file in a secure location and you may need it if you have to configure multiple collectors.

4) Copy the key file to the distribution directory

```bash
cp otel-sa-key.json roles/collector/templates/otel-sa-key.json
```

### Deploy the stack
The stack can be deployed using the following
command:
```bash
ansible-playbook -i hosts site.yml
```

Once done, you can check the results in the Cloud Ops Console. The metrics  might take a few minutes to appear.
