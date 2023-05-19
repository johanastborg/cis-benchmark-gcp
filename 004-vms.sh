#!/bin/bash

# 4 Virtual Machines

###############################################################################
# 4.1 Ensure That Instances Are Not Configured To Use the Default Service Account (Automated)

# List the instances in your project and get details on each instance:
gcloud compute instances list --format=json | jq -r '. | "SA: \(.[].serviceAccounts[].email) Name: \(.[].name)"'

# Stop the instance:
gcloud compute instances stop <INSTANCE_NAME>

# Update the instance:
gcloud compute instances set-service-account <INSTANCE_NAME> --service-account=<SERVICE_ACCOUNT>

# Restart the instance:
gcloud compute instances start <INSTANCE_NAME>

###############################################################################
# 4.2 Ensure That Instances Are Not Configured To Use the Default
# Service Account With Full Access to All Cloud APIs (Automated)

# List the instances in your project and get details on each instance:
gcloud compute instances list --format=json \
	| jq -r '. | "SA Scopes: \(.[].serviceAccounts[].scopes) Name: \(.[].name) Email: \(.[].serviceAccounts[].email)"'
	
# Stop the instance:
gcloud compute instances stop <INSTANCE_NAME>

# Update the instance:
gcloud compute instances set-service-account <INSTANCE_NAME> \
	--service-account=<SERVICE_ACCOUNT> --scopes [SCOPE1, SCOPE2...]
	
# Restart the instance:
gcloud compute instances start <INSTANCE_NAME>

###############################################################################
# 4.3 Ensure "Block Project-Wide SSH Keys" Is Enabled for VM Instances (Automated)

# List the instances in your project and get details on each instance:
gcloud compute instances list --format=json

# To block project-wide public SSH keys, set the metadata value to TRUE:
gcloud compute instances add-metadata <INSTANCE_NAME> --metadata block-project-ssh-keys=TRUE

###############################################################################
# 4.4 Ensure Oslogin Is Enabled for a Project (Automated)

# List the instances in your project and get details on each instance:
gcloud compute instances list --format=json

# Configure oslogin on the project:
gcloud compute project-info add-metadata --metadata enable-oslogin=TRUE

# Remove instance metadata that overrides the project setting:
gcloud compute instances remove-metadata <INSTANCE_NAME> --keys=enable-oslogin

###############################################################################
# 4.5 Ensure ‘Enable Connecting to Serial Ports’ Is Not Enabled for
# VM Instance (Automated)

# Ensure the below command's output shows null:
gcloud compute instances describe <vmName> --zone=<region> \
	--format="json(metadata.items[].key,metadata.items[].value)"
	
# Use the below command to disable:
gcloud compute instances add-metadata <INSTANCE_NAME> --zone=<ZONE> --metadata=serial-port-enable=false

# or
gcloud compute instances add-metadata <INSTANCE_NAME> --zone=<ZONE> --metadata=serial-port-enable=0

###############################################################################
# 4.6 Ensure That IP Forwarding Is Not Enabled on Instances (Automated)

# List all instances:
gcloud compute instances list --format='table(name,canIpForward)'

# Delete the instance:
gcloud compute instances delete INSTANCE_NAME

# Create a new instance to replace it, with IP forwarding set to Off
gcloud compute instances create

###############################################################################
# 4.7 Ensure VM Disks for Critical VMs Are Encrypted With
# Customer-Supplied Encryption Keys (CSEK) (Automated)

# Ensure diskEncryptionKey property in the below command's response is not null, and
# contains key sha256 with corresponding value

gcloud compute disks describe <DISK_NAME> --zone <ZONE> --format="json(diskEncryptionKey,name)"

# encrypt a disk using the --csek-key-file flag during instance creation:
gcloud compute instances create <INSTANCE_NAME> --csek-key-file <example-file.json>

# To encrypt a standalone persistent disk:
gcloud compute disks create <DISK_NAME> --csek-key-file <example-file.json>

###############################################################################
# 4.8 Ensure Compute Instances Are Launched With Shielded VM Enabled (Automated)

# For each instance in your project, get its metadata:
gcloud compute instances list --format=json \
	| jq -r '. | "vTPM: \(.[].shieldedInstanceConfig.enableVtpm) IntegrityMonitoring: 
	\(.[].shieldedInstanceConfig.enableIntegrityMonitoring) Name: \(.[].name)"'
	
# For a list of Shielded VM public images, run:
gcloud compute images list --project gce-uefi-images --no-standard-images

# Stop the instance:
gcloud compute instances stop <INSTANCE_NAME>

# Update the instance:
gcloud compute instances update <INSTANCE_NAME> --shielded-vtpm --shielded-vm-integrity-monitoring

# Optionally, if you do not use any custom or unsigned drivers on the instance, also
# turn on secure boot:
gcloud compute instances update <INSTANCE_NAME> --shielded-vm-secure-boot

# Restart the instance:
gcloud compute instances start <INSTANCE_NAME>

###############################################################################
# 4.9 Ensure That Compute Instances Do Not Have Public IP Addresses (Automated)

# For every VM, ensure that there is no External IP configured:
gcloud compute instances list --format=json

# Describe the instance properties:
gcloud compute instances describe <INSTANCE_NAME> --zone=<ZONE>

# Delete the access config:
gcloud compute instances delete-access-config <INSTANCE_NAME> --zone=<ZONE> \
	--access-config-name <ACCESS_CONFIG_NAME>
	
###############################################################################
# 4.11 Ensure That Compute Instances Have Confidential Computing Enabled (Automated)

# List the instances in your project and get details on each instance:
gcloud compute instances list --format=json

# Ensure that enableConfidentialCompute is set to true for all instances with
# machine type starting with "n2d-":
# confidentialInstanceConfig:
#   enableConfidentialCompute: true

# Create a new instance with Confidential Compute enabled:
gcloud compute instances create <INSTANCE_NAME> --zone <ZONE> --confidential-compute \
	--maintenance-policy=TERMINATE
	
###############################################################################
# 4.12 Ensure the Latest Operating System Updates Are Installed
# On Your Virtual Machines in All Projects (Manual)

# In each project you wish to enable run the following command:
gcloud services list

# Determine if VM Manager is Enabled for the Project:
gcloud compute instances os-inventory describe VM-NAME --zone=ZONE

# Run the following command to view instance data:
gcloud compute instances list --format="table(name,status,tags.list())"

# For project wide tagging, run the following command:
gcloud compute project-info add-metadata \
	--project <PROJECT_ID> \
	--metadata=enable-osconfig=TRUE