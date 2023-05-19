#!/bin/bash

# 3 Networking

###############################################################################
# 3.1 Ensure That the Default Network Does Not Exist in a Project (Automated)

# Set the project name in the Google Cloud Shell:
gcloud config set project PROJECT_ID

# List the networks configured in that project:
gcloud compute networks list

# Delete the default network:
gcloud compute networks delete default

# gcloud compute networks delete default
gcloud compute networks create NETWORK_NAME

###############################################################################
# 3.2 Ensure Legacy Networks Do Not Exist for Older Projects (Automated)

# Set the project name in the Google Cloud Shell:
gcloud config set project <Project-ID>

# List the networks configured in that project:
gcloud compute networks list

###############################################################################
# 3.3 Ensure That DNSSEC Is Enabled for Cloud DNS (Automated)

# List all the Managed Zones in a project:
gcloud dns managed-zones list

# For each zone of VISIBILITY public, get its metadata:
gcloud dns managed-zones describe ZONE_NAME

# Use the below command to enable DNSSEC for Cloud DNS Zone Name.
gcloud dns managed-zones update ZONE_NAME --dnssec-state on

###############################################################################
# 3.4 Ensure That RSASHA1 Is Not Used for the Key-Signing Key
# in Cloud DNS DNSSEC (Automated)

# Ensure the property algorithm for keyType keySigning is not using RSASHA1:
gcloud dns managed-zones describe ZONENAME \
	--format="json(dnsName,dnssecConfig.state,dnssecConfig.defaultKeySpecs)"
	
# To turn off DNSSEC, run the following command:
gcloud dns managed-zones update ZONE_NAME --dnssec-state off

# To update key-signing for a reported managed DNS Zone, run the following:
gcloud dns managed-zones update ZONE_NAME --dnssec-state on --ksk-algorithm KSK_ALGORITHM \
	--ksk-key-length KSK_KEY_LENGTH --zsk-algorithm ZSK_ALGORITHM \
	--zsk-key-length ZSK_KEY_LENGTH --denial-of-existence DENIAL_OF_EXISTENCE

###############################################################################
# 3.5 Ensure That RSASHA1 Is Not Used for the Zone-Signing Key
# in Cloud DNS DNSSEC (Automated)

# Ensure the property algorithm for keyType zone signing is not using RSASHA1:
gcloud dns managed-zones describe --format="json(dnsName,dnssecConfig.state,dnssecConfig.defaultKeySpecs)"

# To turn off DNSSEC, run following command:
gcloud dns managed-zones update ZONE_NAME --dnssec-state off

# To update zone-signing for a reported managed DNS Zone, run the following:
gcloud dns managed-zones update ZONE_NAME --dnssec-state on --ksk-algorithm KSK_ALGORITHM \
	--ksk-key-length KSK_KEY_LENGTH --zsk-algorithm ZSK_ALGORITHM \
	--zsk-key-length ZSK_KEY_LENGTH --denial-of-existence DENIAL_OF_EXISTENCE

###############################################################################
# 3.6 Ensure That SSH Access Is Restricted From the Internet (Automated)

# Ensure IP Ranges is not equal to 0.0.0.0/0 under Source filters:
gcloud compute firewall-rules list --format=table'(name,direction,sourceRanges,allowed)'

# Update the Firewall rule with the new SOURCE_RANGE from the below command:
gcloud compute firewall-rules update FirewallName --allow=[PROTOCOL[:PORT[-PORT]],...] --source-ranges=[CIDR_RANGE,...]

###############################################################################
# 3.7 Ensure That RDP Access Is Restricted From the Internet (Automated)

# Ensure IP Ranges is not equal to 0.0.0.0/0 under Source filters:
gcloud compute firewall-rules list --format=table'(name,direction,sourceRanges,allowed.ports)'

# Update RDP Firewall rule with new SOURCE_RANGE from the below command:
gcloud compute firewall-rules update FirewallName --allow=[PROTOCOL[:PORT[-PORT]],...] --source-ranges=[CIDR_RANGE,...]

###############################################################################
# 3.8 Ensure that VPC Flow Logs is Enabled for Every Subnet in a VPC Network (Automated)

gcloud compute networks subnets list --format json | \
	jq -r
	'(["Subnet","Purpose","Flow_Logs","Aggregation_Interval","Flow_Sampling","Met
	adata","Logs_Filtered"] | (., map(length*"-"))),
	(.[] |
	[
	.name,
	.purpose,
	(if has("enableFlowLogs") and .enableFlowLogs == true then
	"Enabled" else "Disabled" end),
	(if has("logConfig") then .logConfig.aggregationInterval else
	"N/A" end),
	(if has("logConfig") then .logConfig.flowSampling else "N/A"
	end),
	(if has("logConfig") then .logConfig.metadata else "N/A" end),
	(if has("logConfig") then (.logConfig | has("filterExpr")) else
	"N/A" end)
	]
	) |
	@tsv' | column -t

###############################################################################
# 3.9 Ensure No HTTPS or SSL Proxy Load Balancers Permit SSL Policies With Weak Cipher Suites (Manual)

# List all TargetHttpsProxies and TargetSslProxies:
gcloud compute target-https-proxies list
gcloud compute target-ssl-proxies list

# For each target proxy, list its properties:
gcloud compute target-https-proxies describe TARGET_HTTPS_PROXY_NAME
gcloud compute target-ssl-proxies describe TARGET_SSL_PROXY_NAME

# Ensure that the sslPolicy field is present and identifies the name of the SSL policy:
# https://www.googleapis.com/compute/v1/projects/PROJECT_ID/global/sslPolicies/SSL_POLICY_NAME

# Describe the SSL policy:
gcloud compute ssl-policies describe SSL_POLICY_NAME

# Features to disable:
# TLS_RSA_WITH_AES_128_GCM_SHA256
# TLS_RSA_WITH_AES_256_GCM_SHA384
# TLS_RSA_WITH_AES_128_CBC_SHA
# TLS_RSA_WITH_AES_256_CBC_SHA
# TLS_RSA_WITH_3DES_EDE_CBC_SHA

# For each insecure SSL policy, update it to use secure cyphers:
gcloud compute ssl-policies update NAME [--profile COMPATIBLE|MODERN|RESTRICTED|CUSTOM] --min-tls-version 1.2 [--custom-features FEATURES]

# Use the following command corresponding to the proxy type to update it:
gcloud compute target-ssl-proxies update TARGET_SSL_PROXY_NAME --ssl-policy SSL_POLICY_NAME
gcloud compute target-https-proxies update TARGET_HTTPS_POLICY_NAME --ssl-policy SSL_POLICY_NAME