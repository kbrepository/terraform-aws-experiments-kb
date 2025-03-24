# terraform-aws-experiments-kb

# Terraform AWS Experiments 🚀

## Overview
This repository contains a series of Terraform-based labs focused on learning and deploying AWS infrastructure. The projects start from beginner-level deployments (like EC2 instances) and progress towards more advanced setups using Terraform modules and remote backends.

## 🎯 Goals
- Build hands-on expertise with Terraform and AWS services.
- Learn infrastructure as code (IaC) best practices.
- Implement modular and production-like Terraform code.

## 🗂️ Lab Index

| #   | Lab Title                                       | Description                                                      |
| --- | ----------------------------------------------- | ---------------------------------------------------------------- |
| 01  | EC2 Basic Setup                                 | Launch an EC2 instance with SSH access and install NGINX.        |
| 02  | VPC Basic Networking                            | Create a VPC with public and private subnets + NAT Gateway.      |
| 03  | S3 Lambda Event Driven                          | Trigger Lambda function via S3 bucket events and log to CW Logs. |
| 04  | HA WebApp (ALB + ASG)                           | Deploy a scalable web application behind an Application LB.      |
| 05  | Modular Infra + Remote Backend                  | Refactor into modules and use S3 + DynamoDB for remote backend.  |

---

## 🛠️ Usage

1. **Clone this repository**

```bash
git clone https://github.com/<your-github-username>/terraform-aws-experiments-kb.git
cd terraform-aws-labs
