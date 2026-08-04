# Gitea Infrastructure Deployment

## 概要

このプロジェクトは、AWSを使用してサンプルアプリケーションをゼロからデプロイする自己学習型プロジェクトです。ネットワークの基礎からTerraform、Ansible、Docker、CI/CDパイプライン、Kubernetesまで、DevOpsツールチェーン全体を段階的に学びながら構築しています。

## Overview

This is a self-taught, end-to-end learning project focused on deploying a sample application on AWS. It covers the full DevOps toolchain progressively, starting from networking fundamentals up to Terraform, Ansible, Docker, CI/CD pipelines, and Kubernetes.

The sample application deployed is [Gitea](https://about.gitea.com/), a lightweight self-hosted Git service, with a PostgreSQL database backend.

## Learning path / steps

1. **Networking & Linux fundamentals** - IP addressing, subnetting, routing, SSH, permissions
2. **AWS manual setup** - VPC, subnets, security groups, EC2 (created manually first, to understand each component before automating)
3. **Terraform** - Infrastructure as Code, translating the manual setup into reusable code
4. **Ansible** *(in progress)* - automated configuration of EC2 instances
5. **Docker** *(in progress)* - containerizing the Gitea application
6. **GitLab CI/CD** *(planned)* - automated pipeline for infrastructure and application deployment
7. **Harbor** *(planned)* - container registry
8. **Kubernetes (EKS)** *(planned)* - final orchestration layer
## Learning resources

This project was built while learning from the following resources:

- [Stephane Robert's blog](https://blog.stephane-robert.info/docs/reseaux/) - networking fundamentals and Infrastructure as Code guides
- [AWS Fundamentals (YouTube)](https://www.youtube.com/watch?v=7HKot-brXFE) - AWS core concepts
## Architecture

```
VPC (10.0.0.0/16)
├── Public subnet (10.0.1.0/24)
│   ├── EC2: Gitea application server
│   └── NAT Gateway
│
└── Private subnet (10.0.2.0/24)
    └── EC2: PostgreSQL database server (not exposed to the internet)
```

The database instance is only reachable from the Gitea server's security group, never directly from the internet. The private subnet reaches the internet only through the NAT Gateway (outbound only), following the principle of least privilege.

## Tech stack

- **Infrastructure as Code**: Terraform
- **Cloud provider**: AWS (VPC, EC2, NAT Gateway, Security Groups)
- **Application**: Gitea (self-hosted Git service)
- **Database**: PostgreSQL
- Coming soon: Ansible, Docker, GitLab CI/CD, Harbor, Kubernetes (EKS)
## Deployment

```bash
cd terraform
terraform init
terraform plan -var="my_ip=YOUR_IP_ADDRESS"
terraform apply -var="my_ip=YOUR_IP_ADDRESS"
```

## Project status

Base infrastructure (Terraform) complete. Ansible configuration, Docker deployment, CI/CD pipeline, and Kubernetes migration are in progress.

## License

MIT