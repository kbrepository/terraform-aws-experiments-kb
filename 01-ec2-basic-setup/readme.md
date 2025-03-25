# Lab 01 - Basic EC2 Instance Setup 🖥️

## Description
This Terraform configuration deploys a simple EC2 instance in AWS with a security group that allows SSH (port 22) and HTTP (port 80) access. The instance will install and start NGINX automatically via user_data.

## ⚙️ Resources Provisioned
- EC2 Instance (Amazon Linux 2)
- Security Group (SSH + HTTP inbound access)

## 📝 Variables
| Name           | Description                             | Default       |
|----------------|-----------------------------------------|---------------|
| aws_region     | The AWS region to deploy resources      | us-east-1     |
| instance_type  | EC2 instance type                       | t2.micro      |
| key_name       | EC2 Key Pair name for SSH access        | n/a (required)|
| instance_name  | Name tag for the EC2 instance           | terraform-ec2-instance |

## 🚀 Usage

```bash
terraform init
terraform plan -var="key_name=<your-key-pair>"
terraform apply -var="key_name=<your-key-pair>"
