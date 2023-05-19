#!/bin/bash

# 2 Logging and Monitoring

###############################################################################
# 2.1 Ensure That Cloud Audit Logging Is Configured Properly (Automated)

# List the Identity and Access Management (IAM) policies for the project, folder, or organization:
gcloud organizations get-iam-policy ORGANIZATION_ID
gcloud resource-manager folders get-iam-policy FOLDER_ID
gcloud projects get-iam-policy PROJECT_ID

# To read the project's IAM policy and store it in a file run a command:
gcloud projects get-iam-policy PROJECT_ID > /tmp/project_policy.yaml

# Alternatively:
gcloud organizations get-iam-policy ORGANIZATION_ID > /tmp/org_policy.yaml
gcloud resource-manager folders get-iam-policy FOLDER_ID > /tmp/folder_policy.yaml

# To write new IAM policy run command:
gcloud organizations set-iam-policy ORGANIZATION_ID /tmp/org_policy.yaml
gcloud resource-manager folders set-iam-policy FOLDER_ID /tmp/folder_policy.yaml
gcloud projects set-iam-policy PROJECT_ID /tmp/project_policy.yaml

###############################################################################
# 2.2 Ensure That Sinks Are Configured for All Log Entries (Automated)

# Ensure that a sink with an empty filter exists:

gcloud logging sinks list --folder=FOLDER_ID 
gcloud logging sinks list --organization=ORGANIZATION_ID 
gcloud logging sinks list --project=PROJECT_ID

# To create a sink to export all log entries in a Google Cloud Storage bucket:
gcloud logging sinks create <sink-name> storage.googleapis.com/DESTINATION_BUCKET_NAME

# Sinks can be created for a folder or organization, which will include all projects:
gcloud logging sinks create <sink-name> torage.googleapis.com/DESTINATION_BUCKET_NAME \
	--include-children --folder=FOLDER_ID

gcloud logging sinks create <sink-name> torage.googleapis.com/DESTINATION_BUCKET_NAME \
	--include-children --organization=ORGANIZATION_ID

###############################################################################
# 2.3 Ensure That Retention Policies on Cloud Storage Buckets
# Used for Exporting Logs Are Configured Using Bucket Lock (Automated)

# To list all sinks destined to storage buckets:
gcloud logging sinks list --folder=FOLDER_ID
gcloud logging sinks list --organization=ORGANIZATION_ID
gcloud logging sinks list --project=PROJECT_ID

# For every storage bucket listed above, verify that retention policies and Bucket Lock are enabled:
gsutil retention get gs://BUCKET_NAME

# To list all sinks destined to storage buckets:
gcloud logging sinks list --folder=FOLDER_ID
gcloud logging sinks list --organization=ORGANIZATION_ID
gcloud logging sinks list --project=PROJECT_ID

# For each storage bucket listed above, set a retention policy and lock it:
gsutil retention set [TIME_DURATION] gs://[BUCKET_NAME]
gsutil retention lock gs://[BUCKET_NAME]

###############################################################################
# 2.4 Ensure Log Metric Filter and Alerts Exist for Project
# Ownership Assignments/Changes (Automated)

# List the log metrics:
gcloud logging metrics list --format json

# List the alerting policies:
gcloud alpha monitoring policies list --format json

###############################################################################
# 2.5 Ensure That the Log Metric Filter and Alerts Exist for Audit
# Configuration Changes (Automated)

# List the log metrics:
gcloud beta logging metrics list --format json

# Ensure that the output contains at least one metric with the filter set to:
# protoPayload.methodName="SetIamPolicy" AND
# protoPayload.serviceData.policyDelta.auditConfigDeltas:*

# List the alerting policies:
gcloud alpha monitoring policies list --format json

###############################################################################
# 2.6 Ensure That the Log Metric Filter and Alerts Exist for Custom
# Role Changes (Automated)

# List the log metrics:
gcloud logging metrics list --format json

# Ensure that the output contains at least one metric with the filter set to:
# resource.type="iam_role"
# AND (protoPayload.methodName = "google.iam.admin.v1.CreateRole" OR
# protoPayload.methodName="google.iam.admin.v1.DeleteRole" OR
# protoPayload.methodName="google.iam.admin.v1.UpdateRole")

# List the alerting policies:
gcloud alpha monitoring policies list --format json

###############################################################################
# 2.7 Ensure That the Log Metric Filter and Alerts Exist for VPC
# Network Firewall Rule Changes (Automated)

# List the log metrics:
gcloud logging metrics list --format json

# Ensure that the output contains at least one metric with the filter set to:
# resource.type="gce_firewall_rule"
# AND (protoPayload.methodName:"compute.firewalls.patch"
# OR protoPayload.methodName:"compute.firewalls.insert"
# OR protoPayload.methodName:"compute.firewalls.delete")

# List the alerting policies:
gcloud alpha monitoring policies list --format json

###############################################################################
# 2.8 Ensure That the Log Metric Filter and Alerts Exist for VPC
# Network Route Changes (Automated)

# List the log metrics:
gcloud logging metrics list --format json

# Ensure that the output contains at least one metric with the filter set to:
# resource.type="gce_route"
# AND (protoPayload.methodName:"compute.routes.delete"
# OR protoPayload.methodName:"compute.routes.insert")

# List the alerting policies:
gcloud alpha monitoring policies list --format json

###############################################################################
# 2.9 Ensure That the Log Metric Filter and Alerts Exist for VPC
# Network Changes (Automated)

# List the log metrics:
gcloud logging metrics list --format json

# Ensure that the output contains at least one metric with filter set to:
# resource.type="gce_network"
# AND protoPayload.methodName="beta.compute.networks.insert"
# OR protoPayload.methodName="beta.compute.networks.patch"
# OR protoPayload.methodName="v1.compute.networks.delete"
# OR protoPayload.methodName="v1.compute.networks.removePeering"
# OR protoPayload.methodName="v1.compute.networks.addPeering"

# List the alerting policies:
gcloud alpha monitoring policies list --format json

###############################################################################
# 2.10 Ensure That the Log Metric Filter and Alerts Exist for Cloud
# Storage IAM Permission Changes (Automated)

# List the log metrics:
gcloud logging metrics list --format json

# Ensure that the output contains at least one metric with the filter set to:
# resource.type=gcs_bucket
# AND protoPayload.methodName="storage.setIamPermissions"

# List the alerting policies:
gcloud alpha monitoring policies list --format json

###############################################################################
# 2.11 Ensure That the Log Metric Filter and Alerts Exist for SQL
# Instance Configuration Changes (Automated)

# List the log metrics:
gcloud logging metrics list --format json

# Ensure that the output contains at least one metric with the filter set to:
# protoPayload.methodName="cloudsql.instances.update"

# List the alerting policies:
gcloud alpha monitoring policies list --format json

###############################################################################
# 2.12 Ensure That Cloud DNS Logging Is Enabled for All VPC Networks (Automated)

# List all VPCs networks in a project:
gcloud compute networks list --format="table[box,title='All VPC Networks'](name:label='VPC Network Name')"

#List all DNS policies, logging enablement, and associated VPC networks:
gcloud dns policies list --flatten="networks[]" --
	format="table[box,title='All DNS Policies By VPC Network'](name:label='Policy
	Name',enableLogging:label='Logging
	Enabled':align=center,networks.networkUrl.basename():label='VPC Network
	Name')"

# For each VPC network that needs a DNS policy with logging enabled:
gcloud dns policies create enable-dns-logging --enable-logging \ 
	--description="Enable DNS Logging" --networks=VPC_NETWORK_NAME

# For each VPC network that has an existing DNS policy that needs logging enabled:
gcloud dns policies update POLICY_NAME --enable-logging --networks=VPC_NETWORK_NAME

###############################################################################
# 2.13 Ensure Cloud Asset Inventory Is Enabled (Automated)

# Query enabled services:
gcloud services list --enabled --filter=name:cloudasset.googleapis.com

# Enable the Cloud Asset API through the services interface:
gcloud services enable cloudasset.googleapis.com

###############################################################################
# 2.15 Ensure 'Access Approval' is 'Enabled' (Automated)

# From within the project you wish to audit, run the following command.
gcloud access-approval settings get

# To update all services in an entire project, run the following command
gcloud access-approval settings update --project=<project name> --enrolled_services=all \
	--notification_emails='<email recipient for access approval requests>@<domain name>'
	
###############################################################################
# 2.16 Ensure Logging is enabled for HTTP(S) Load Balancer (Automated)

# Run the following command
gcloud compute backend-services describe <serviceName>

# Run the following command
gcloud compute backend-services update <serviceName> --region=REGION \
	--enable-logging --logging-sample-rate=<percentageAsADecimal>
