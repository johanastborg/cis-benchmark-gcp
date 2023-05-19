#!/bin/bash

# 1 Identity and Access Management

###############################################################################
# 1.1 Ensure that Corporate Login Credentials are Used (Manual)

gcloud projects get-iam-policy PROJECT_ID
gcloud resource-manager folders get-iam-policy FOLDER_ID
gcloud organizations get-iam-policy ORGANIZATION_ID

###############################################################################
# 1.3 Ensure that Security Key Enforcement is Enabled for All 
# Admin Accounts (Manual)

gcloud organizations get-iam-policy ORGANIZATION_ID

###############################################################################
# 1.4 Ensure That There Are Only GCP-Managed Service Account
# Keys for Each Service Account (Automated)

# List All the service accounts:
gcloud iam service-accounts list

gcloud iam service-accounts keys list --iam-account=<Service Account> --managed-by=user

# To delete a user managed Service Account Key
gcloud iam service-accounts keys delete --iam-account=<user-managed-service-account-EMAIL> <KEY-ID>

###############################################################################
# 1.5 Ensure That Service Account Has No Admin Privileges (Automated)
gcloud projects get-iam-policy PROJECT_ID --format json > iam.json

###############################################################################
# 1.6 Ensure That IAM Users Are Not Assigned the Service
# Account User or Service Account Token Creator Roles at Project
# Level (Automated)

# Ensure IAM users are not assigned Service Account User role at the project level:
gcloud projects get-iam-policy PROJECT_ID --format json | jq '.bindings[].role' | grep "roles/iam.serviceAccountUser"
gcloud projects get-iam-policy PROJECT_ID --format json | jq '.bindings[].role' | grep "roles/iam.serviceAccountTokenCreator"

# Update the project's IAM policy:
gcloud projects set-iam-policy PROJECT_ID iam.json

###############################################################################
# 1.7 Ensure User-Managed/External Keys for Service Accounts
# Are Rotated Every 90 Days or Fewer (Automated)

# List all Service accounts from a project
gcloud iam service-accounts list

# For every service account list service account keys
gcloud iam service-accounts keys list --iam-account [Service_Account_Email_Id] --format=json

# Ensure every service account key for a service account has a "validAfterTime" value within the past 90 days

###############################################################################
# 1.8 Ensure That Separation of Duties Is Enforced While Assigning
# Service Account Related Roles to Users (Automated)

# List all users and role assignments:
gcloud projects get-iam-policy [Project_ID] --format json | \
jq -r '[
(["Service_Account_Admin_and_User"] | (., map(length*"-"))),
(
[
.bindings[] |
select(.role == "roles/iam.serviceAccountAdmin" or .role ==
"roles/iam.serviceAccountUser").members[]
] |
group_by(.) |
map({User: ., Count: length}) |
.[] |
select(.Count == 2).User |
unique
)
] |
.[] |
@tsv'

###############################################################################
# 1.9 Ensure That Cloud KMS Cryptokeys Are Not Anonymously or
# Publicly Accessible (Automated)

# List all Cloud KMS Cryptokeys
gcloud kms keys list --keyring=[key_ring_name] --location=global --format=json | jq '.[].name'

# Ensure the below command's output does not contain allUsers or allAuthenticatedUsers
gcloud kms keys get-iam-policy [key_name] --keyring=[key_ring_name] --location=global --format=json | jq '.bindings[].members[]'

# Remove IAM policy binding for a KMS key to remove access to allUsers and allAuthenticatedUsers using the below command
gcloud kms keys remove-iam-policy-binding [key_name] -- \
	keyring=[key_ring_name] --location=global --member='allAuthenticatedUsers' -- \
	role='[role]'

gcloud kms keys remove-iam-policy-binding [key_name] -- \
	keyring=[key_ring_name] --location=global --member='allUsers' --role='[role]'

###############################################################################
# 1.10 Ensure KMS Encryption Keys Are Rotated Within a Period of 90 Days (Automated)

# Ensure rotation is scheduled by ROTATION_PERIOD and NEXT_ROTATION_TIME for each key
gcloud kms keys list --keyring=<KEY_RING> --location=<LOCATION> --format=json'(rotationPeriod)'

# Update and schedule rotation by ROTATION_PERIOD and NEXT_ROTATION_TIME for each key:
gcloud kms keys update new --keyring=KEY_RING --location=LOCATION --next-rotation-time=NEXT_ROTATION_TIME --rotation-period=ROTATION_PERIOD

###############################################################################
# 1.11 Ensure That Separation of Duties Is Enforced While
# Assigning KMS Related Roles to Users (Automated)

gcloud projects get-iam-policy PROJECT_ID

###############################################################################
# 1.12 Ensure API Keys Only Exist for Active Services (Automated)

gcloud services api-keys list --filter
gcloud alpha services api-keys delete

###############################################################################
# 1.13 Ensure API Keys Are Restricted To Use by Only Specified Hosts and Apps (Manual)

gcloud services api-keys list --filter="-restrictions:*" --format="table[box](displayName:label='Key With No Restrictions')"

###############################################################################
# 1.14 Ensure API Keys Are Restricted to Only APIs ThatApplication Needs Access (Automated)

# List all API Keys
gcloud services api-keys list

gcloud alpha services api-keys update <UID> <restriction_flags>

gcloud alpha services api-keys update --help

###############################################################################
# 1.15 Ensure API Keys Are Rotated Every 90 Days (Automated)

gcloud services api-keys list

gcloud alpha services api-keys create --display-name="<key_name>"

gcloud alpha services api-keys update <UID of new key>

gcloud alpha services api-keys delete <UID of old key>

###############################################################################
# 1.16 Ensure Essential Contacts is Configured for Organization (Automated)

gcloud essential-contacts list --organization=<ORGANIZATION_ID>

# Add an organization Essential Contacts run a command:
gcloud essential-contacts create --email="<EMAIL>" \
	--notification-categories="<NOTIFICATION_CATEGORIES>" \
	--organization=<ORGANIZATION_ID>

###############################################################################
# 1.17 Ensure that Dataproc Cluster is encrypted using Customer-Managed Encryption Key (Automated)

# Set project
gcloud config set project <project_ID>

# Run clusters list command to list all the Dataproc Clusters available in the region:
gcloud dataproc clusters list --region='us-central1'

# Run clusters describe command to get the key details of the selected cluster:
gcloud dataproc clusters describe <cluster_name> --region=us-central1 \
	--flatten=config.encryptionConfig.gcePdKmsKeyName


# gcloud config set project <project_ID>"

# Run clusters create command to create new cluster with customer-managed key:
gcloud dataproc clusters create <cluster_name> --region=us-central1 --gce-pd-kms-key=<key_resource_name>

gcloud dataproc clusters delete <cluster_name> --region=us-central1

###############################################################################
# 1.18 Ensure Secrets are Not Stored in Cloud Functions Environment Variables by Using Secret Manager (Manual)

# To view a list of your cloud functions run
gcloud functions list

# For each cloud function in the list run the following command.
gcloud functions describe <function_name>

gcloud services list
gcloud services enable Secret Manager API

gcloud secrets create <secret-id> --data-file="/path/to/file.txt"
gcloud functions deploy <Function name>--remove-env-vars <env vars>


