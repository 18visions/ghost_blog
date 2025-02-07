# AWS Infrastructure for Ghost Deployment

This repository provisions and configures AWS resources needed to deploy a Ghost instance using Ansible. The infrastructure includes resources such as an EC2 instance, IAM policies and roles, security groups, S3 buckets (and their objects), and related attachments.

The EC2 instance is configured with a **user_data** script that downloads an Ansible zip file from an S3 bucket and executes the playbook locally to install and configure Ghost using:

```bash
ansible-playbook -i "127.0.0.1," install_ghost.yaml
```

## Overview

This project automates the creation of AWS resources required for deploying Ghost. The primary components include:
- EC2 Instance: Hosts the Ghost installation.
- IAM Role & Policies: Define permissions for the EC2 instance.
- Security Group: Controls network traffic to the instance.
- S3 Bucket & Objects: Stores the Ansible zip file containing the playbook and any additional configuration files.
- IAM Policy Attachments: Attach policies to the IAM role to grant necessary AWS permissions.
