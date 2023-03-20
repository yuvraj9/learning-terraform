# Learning Terraform

Created a basic infrastructure on aws using terraform

## Architecure


![architecure-diagram](https://user-images.githubusercontent.com/56301121/226250093-fbd1b10c-5369-4895-99f1-a495908c2af8.png)

## Components
- VPC
- Subnets
- Internet Gateway
- NAT Gateway
- Security Groups
- EC2 Instances - nginx, postgres
- Loadbalancer

## Usage
- Update the variables.tf with the values for your environment
- You need aws cli and pre configured with access key and secret key
- Run below commands to run terraform
```
    - terraform init
    - terraform plan
    - terraform apply
```