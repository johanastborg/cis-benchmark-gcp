#!/bin/bash

# 7 BigQuery

###############################################################################
# 7.1 Ensure That BigQuery Datasets Are Not Anonymously or Publicly Accessible (Automated)

# List the name of all datasets:
bq ls

# Retrieve each dataset details using the following command:
bq show PROJECT_ID:DATASET_NAME

# List the name of all datasets:
bq ls

# Retrieve the data set details:
bq show --format=prettyjson PROJECT_ID:DATASET_NAME > PATH_TO_FILE

# Update the dataset:
bq update --source PATH_TO_FILE PROJECT_ID:DATASET_NAME

###############################################################################
# 7.2 Ensure That All BigQuery Tables Are Encrypted With
# Customer-Managed Encryption Key (CMEK) (Automated)

# List all dataset names:
bq ls

# Use the following command to view the table details. Verify the kmsKeyName is present:
bq show <table_object>

# Use the following command to copy the data:
bq cp --destination_kms_key <customer_managed_key> \
	source_dataset.source_table destination_dataset.destination_table

###############################################################################
# 7.3 Ensure That a Default Customer-Managed Encryption Key
# (CMEK) Is Specified for All BigQuery Data Sets (Automated)

# List all dataset names:
bq ls

# Use the following command to view each dataset details:
bq show <data_set_object>