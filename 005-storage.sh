#!/bin/bash

# 5 Storage

###############################################################################
# 5.1 Ensure That Cloud Storage Bucket Is Not Anonymously or Publicly Accessible (Automated)

# List all buckets in a project
gsutil ls

# Check the IAM Policy for each bucket:
gsutil iam get gs://BUCKET_NAME

# Remove allUsers and allAuthenticatedUsers access:
gsutil iam ch -d allUsers gs://BUCKET_NAME
gsutil iam ch -d allAuthenticatedUsers gs://BUCKET_NAME

###############################################################################
# 5.2 Ensure That Cloud Storage Buckets Have Uniform Bucket-Level Access Enabled (Automated)

# List all buckets in a project:
gsutil ls

# For each bucket, verify that uniform bucket-level access is enabled:
gsutil uniformbucketlevelaccess get gs://BUCKET_NAME/

# Use the on option in a uniformbucketlevelaccess set command:
gsutil uniformbucketlevelaccess set on gs://BUCKET_NAME/