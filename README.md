# AWS VPC Web Server with Terraform

A complete AWS infrastructure deployment using Terraform that creates a VPC with a publicly accessible web server.

## Overview

This project demonstrates Infrastructure as Code (IaC) principles by deploying a complete AWS web server infrastructure using Terraform. It creates a VPC, public subnet, EC2 instance, and all necessary networking components to host a web application.

## Architecture

- **VPC**: Custom Virtual Private Cloud with DNS support
- **Public Subnet**: Internet-accessible subnet in first available AZ
- **Internet Gateway**: Provides internet access
- **Route Table**: Routes traffic between subnet and internet gateway
- **Security Group**: Controls inbound/outbound traffic (HTTP, HTTPS, SSH)
- **EC2 Instance**: t2.micro Amazon Linux 2 instance
- **Apache Web Server**: Automatically installed and configured

## Project Structure

```
├── main.tf          # Main infrastructure resources
├── variables.tf     # Input variables and defaults
├── outputs.tf       # Output values after deployment
├── terraform.tf     # Terraform and provider requirements
├── userdata.tf      # User data script configuration
├── userdata.sh      # Shell script for server setup
└── README.md        # This file
```

## Quick Start

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- SSH key pair (will be generated if needed)

### Installation & Deployment

1. **Clone and navigate to the project:**
   ```bash
   git clone <your-repo-url>
   cd aws-vpc-webserver
   ```

2. **Generate SSH key pair** (if you don't have one):
   ```bash
   ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
   ```

3. **Initialize Terraform:**
   ```bash
   terraform init
   ```

4. **Review the deployment plan:**
   ```bash
   terraform plan
   ```

5. **Deploy the infrastructure:**
   ```bash
   terraform apply
   ```

6. **Access your web server:**
   - The web server URL will be displayed in the output
   - Visit `http://<public-ip>` in your browser

## Configuration

### Default Variables

| Variable | Default Value | Description |
|----------|---------------|-------------|
| `aws_region` | `us-east-1` | AWS region for deployment |
| `project_name` | `web-server` | Project name used in resource tags |
| `environment` | `dev` | Environment name (dev, staging, prod) |
| `vpc_cidr` | `10.0.0.0/16` | CIDR block for VPC |
| `public_subnet_cidr` | `10.0.1.0/24` | CIDR block for public subnet |
| `instance_type` | `t2.micro` | EC2 instance type |

### Customization

To customize the deployment, you can:

1. **Modify variables in `variables.tf`**
2. **Create a `terraform.tfvars` file:**
   ```hcl
   aws_region = "us-west-2"
   project_name = "my-web-app"
   environment = "production"
   instance_type = "t3.small"
   ```

## Commands

| Command | Description |
|---------|-------------|
| `terraform init` | Initialize Terraform working directory |
| `terraform plan` | Preview changes before applying |
| `terraform apply` | Create/update infrastructure |
| `terraform destroy` | Remove all created resources |
| `terraform output` | Display output values |
| `terraform fmt` | Format Terraform files |
| `terraform validate` | Validate configuration syntax |

## Outputs

After successful deployment, you'll get:

- **VPC ID**: ID of the created VPC
- **Public Subnet ID**: ID of the public subnet
- **Security Group ID**: ID of the web server security group
- **Instance ID**: EC2 instance identifier
- **Public IP**: Public IP address of the web server
- **Public DNS**: Public DNS name of the instance
- **Web Server URL**: Direct link to access the web server
- **SSH Command**: Ready-to-use SSH connection command

## Security Considerations

**Important Security Notes:**

- SSH access is currently open to `0.0.0.0/0` (entire internet)
- For production use, restrict SSH access to your IP:
  ```hcl
  cidr_blocks = ["YOUR_IP/32"]
  ```
- Consider using AWS Systems Manager Session Manager instead of SSH
- Enable CloudTrail and VPC Flow Logs for monitoring
- Use IAM roles instead of hardcoded credentials

## Cleanup

To remove all created resources and avoid charges:

```bash
terraform destroy
```

**Note:** This will permanently delete all resources created by this project.

## Troubleshooting

### Common Issues

1. **Terraform Init Timeout:**
   ```bash
   export TF_HTTP_TIMEOUT=600s
   terraform init
   ```

2. **SSH Key Not Found:**
   ```bash
   ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
   ```

3. **AWS Credentials Not Configured:**
   ```bash
   aws configure
   ```

4. **Instance Not Accessible:**
   - Check security group rules
   - Verify instance is in running state
   - Ensure route table has internet gateway route

## What's Next?

Potential improvements and learning exercises:

- [ ] Add multiple availability zones for high availability
- [ ] Implement Application Load Balancer
- [ ] Add RDS database
- [ ] Set up CloudWatch monitoring
- [ ] Implement auto-scaling group
- [ ] Add SSL certificate with ACM
- [ ] Create private subnets for databases
- [ ] Add NAT Gateway for private subnet internet access
- [ ] Implement backup strategies
- [ ] Add CI/CD pipeline integration

## Learning Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS VPC User Guide](https://docs.aws.amazon.com/vpc/latest/userguide/)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)

## License

This project is open source and available under the [MIT License](LICENSE).

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the issues page.

---

**Built with Terraform and AWS**
