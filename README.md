# 🛡️ CIS Benchmark for Google Cloud Platform (GCP)

Welcome to the **CIS Benchmark for GCP** repository! This collection of scripts is designed to help you audit and secure your Google Cloud Platform environment according to the [CIS Google Cloud Platform Foundation Benchmark](https://www.cisecurity.org/benchmark/google_cloud_computing_platform).

## 🚀 Mission

The goal of this project is to simplify the process of verifying your GCP infrastructure against industry-standard security best practices. Whether you are a security engineer, a DevOps professional, or a cloud administrator, these scripts provide a starting point for auditing and hardening your cloud environment.

## 📋 Prerequisites

Before you begin, ensure you have the following tools installed and configured:

*   **[Google Cloud SDK (gcloud)](https://cloud.google.com/sdk/docs/install)**: The command-line tool for Google Cloud.
*   **[jq](https://stedolan.github.io/jq/)**: A lightweight and flexible command-line JSON processor (required for parsing JSON output from `gcloud`).

You also need to be authenticated and have the necessary permissions to view IAM policies and resource configurations.

```bash
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
```

## 🛠️ Usage

These scripts are mapped to the sections of the CIS Benchmark. They contain `gcloud` commands to **audit** (check current status) and sometimes **remediate** (fix issues) your configuration.

**⚠️ IMPORTANT:**
*   **Review before running:** Most scripts contain placeholders like `PROJECT_ID`, `ORGANIZATION_ID`, or `FOLDER_ID`. You must replace these with your actual values.
*   **Manual Execution:** These are not "click-and-run" automation scripts. They are intended to be read and executed command-by-command or section-by-section. Many checks require manual interpretation of the output.
*   **Non-Destructive Audits:** The audit commands are generally read-only (`get`, `list`, `describe`).
*   **Remediation:** Commands that modify resources (`set`, `update`, `delete`) should be used with extreme caution.

### Example

To check Identity and Access Management (IAM) controls:

1.  Open `001-iam.sh`.
2.  Locate the section you are interested in (e.g., "1.4 Ensure That There Are Only GCP-Managed Service Account Keys").
3.  Run the audit command:
    ```bash
    gcloud iam service-accounts list
    ```
4.  Analyze the output.

## 📂 Scripts Overview

| Script | Domain | Description |
| :--- | :--- | :--- |
| `001-iam.sh` | **Identity & Access Management** | Covers service accounts, API keys, KMS, and role separation. |
| `002-logmon.sh` | **Logging & Monitoring** | Audits VPC flow logs, audit logging, and sink configurations. |
| `003-networking.sh` | **Networking** | Checks firewall rules, SSL policies, and network configurations. |
| `004-vms.sh` | **Virtual Machines** | Verifies instance settings, shielded VMs, and SSH key management. |
| `005-storage.sh` | **Storage** | Audits Cloud Storage bucket permissions and retention policies. |
| `006-cloudsql.sh` | **Cloud SQL** | Checks database instance flags, backups, and SSL configurations. |
| `007-bigquery.sh` | **BigQuery** | Reviews dataset permissions and encryption settings. |

## ⚠️ Disclaimer

These scripts are provided **as-is** without warranty of any kind. They are intended for educational and auditing purposes. **Always test remediation commands in a non-production environment first.** The authors are not responsible for any disruption or data loss caused by the use of these scripts.

## 🤝 Contributing

Contributions are welcome! If you find a bug, have an improvement, or want to add coverage for a new CIS Benchmark version:

1.  Fork the repository.
2.  Create a feature branch (`git checkout -b feature/amazing-feature`).
3.  Commit your changes.
4.  Push to the branch.
5.  Open a Pull Request.

## 📄 License

[MIT License](LICENSE) (or as specified in the repository).

---
*Stay Secure!* 🔒
