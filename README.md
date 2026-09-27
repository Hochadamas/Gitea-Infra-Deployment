# Gitea Infrastructure Deployment

## 概要

AWS上にGiteaおよびPostgreSQLを段階的にデプロイしたDevOpsプロジェクトです。ネットワークの基礎構築から始まり、TerraformによるIaC化、Ansibleでの構成管理、Docker/Harborでのコンテナ化、GitLab CI/CDでのセキュリティスキャン、最終的にAmazon EKS環境への移行までを実装しています。

## Overview

Self-hosted DevOps pipeline and infrastructure deployment for Gitea (with PostgreSQL backend) on AWS. The project evolves step-by-step from manual VPC/EC2 provisioning to Terraform IaC, Ansible configuration, Docker containerization, GitLab CI/CD pipelines, and a complete Kubernetes (EKS) migration.

The application deployed is [Gitea](https://about.gitea.com/), a lightweight self-hosted Git service backed by PostgreSQL.

## Technical Evolution

1. **Networking & EC2 Basics** — Built manual AWS VPC, subnets, routing, and EC2 instances to baseline infrastructure requirements.
2. **Terraform (IaC)** — Automated the core infrastructure setup into reusable Terraform code.
3. **Ansible & Configuration** — Automated Gitea and PostgreSQL setups on EC2; encrypted sensitive variables using Ansible Vault.
4. **Containerization & Hardening** — Wrote hardened Dockerfiles, configured Docker Compose setups, and ran local image vulnerability audits with Trivy.
5. **GitLab CI/CD Integration** — Integrated automated pipeline triggers to execute Trivy security scans on every repo push.
6. **Harbor Registry** — Configured and tested Harbor locally as a private container registry and scan-on-push repository.
7. **Kubernetes (EKS)** — Provisioned AWS EKS clusters via Terraform and migrated application components to Kubernetes with EBS CSI storage.

## Learning Resources

This project was built while referencing the following resources:

- [Stephane Robert's blog](https://blog.stephane-robert.info/docs/reseaux/) — Networking fundamentals and IaC guides
- [AWS Fundamentals (YouTube)](https://www.youtube.com/watch?v=7HKot-brXFE) — AWS core concepts

## Architecture

### EKS Cluster (Active Setup)

```
VPC (10.0.0.0/16)
├── Public Subnets ──> EKS Managed Node Groups (Worker Nodes)
└── Private Subnets ──> NAT Gateway / Egress Traffic

EKS Cluster Topology
├── Gitea — Deployment + ClusterIP Service (ConfigMap & Secret mounts)
├── PostgreSQL — StatefulSet + Headless Service (EBS-backed dynamic persistent volumes via AWS EBS CSI)
└── Cluster Add-ons — vpc-cni, kube-proxy, coredns, aws-ebs-csi-driver (IRSA authentication)
```

### Legacy Setup: Standalone EC2 (Steps 2–4)

​```
VPC (10.0.0.0/16)
├── Public subnet (10.0.1.0/24)
│   ├── EC2: Gitea application server
│   └── NAT Gateway
│
└── Private subnet (10.0.2.0/24)
    └── EC2: PostgreSQL database server (not exposed to the internet)
​```

Kept in the Terraform code (commented out) for comparison purposes. The database instance was only reachable from the Gitea server's security group.

## Tech Stack

- **Infrastructure as Code**: Terraform (`terraform-aws-modules/eks/aws`)
- **Configuration Management**: Ansible (+ Ansible Vault for secrets)
- **Containerization**: Docker, Docker Compose, Harbor
- **Orchestration**: Kubernetes (Amazon EKS)
- **CI/CD & Security**: GitLab CI/CD, Trivy
- **Application**: Gitea
- **Database**: PostgreSQL

## Repository Structure

```text
├── terraform/      # Infrastructure as Code (VPC, legacy EC2, EKS)
├── ansible/        # Playbooks for the EC2-based deployment (Vault-encrypted secrets)
├── kubernetes/     # Manifests for EKS deployment (StorageClass, PostgreSQL, Gitea)
└── .gitlab-ci.yml  # CI/CD pipeline (Trivy scan on push)

```
## Deployment Guide

### Prerequisites

- Terraform ≥ 1.x
- AWS CLI configured with valid credentials
- kubectl
- AWS Account (Note: EKS Control Plane incurs standard hourly charges)

### 1. Provision Infrastructure

```bash
cd terraform
terraform init -upgrade
terraform plan
terraform apply
```

> Note: The EKS node group depends on the `vpc-cni` add-on being active before registering healthy nodes. If provisioning from scratch, apply in two passes: first with `eks_managed_node_groups` and the `coredns`/`aws-ebs-csi-driver` add-ons commented out, then a second `apply` with everything enabled once the cluster's networking add-ons are active.

### 2. Configure Local Kubernetes Context

```bash
aws eks update-kubeconfig --name <cluster_name> --region <region>
```

### 3. Deploy Kubernetes Workloads

```bash
kubectl apply -f kubernetes/storageclass.yaml
kubectl apply -f kubernetes/postgres.yaml
kubectl apply -f kubernetes/gitea.yaml
```

### 4. Access Application

```bash
kubectl port-forward svc/gitea-service 3000:3000
```

### Cleanup

To teardown all active AWS resources and avoid ongoing charges (EKS control plane, NAT Gateway, EBS volumes):

```bash
terraform destroy
```

## Project Status

Complete — End-to-end infrastructure pipeline deployed and validated on AWS EKS.

## License

MIT