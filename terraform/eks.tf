module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 20.31"

  name               = "gitea-infra-eks"
  kubernetes_version = "1.34"

  vpc_id     = aws_vpc.main.id
  subnet_ids = [aws_subnet.private.id, aws_subnet.private_2.id]

  endpoint_public_access  = true
  endpoint_private_access = false

  enable_cluster_creator_admin_permissions = true

  addons = {
    vpc-cni = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = module.irsa_ebs_csi.iam_role_arn
    }

  }

  eks_managed_node_groups = {
    default = {
      instance_types             = ["t3.small"]
      min_size                   = 1
      max_size                   = 1
      desired_size               = 1
      use_custom_launch_template = false
    }
  }

  tags = {
    Name = "gitea-infra-eks"
  }
}

module "irsa_ebs_csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name             = "ebs-csi-irsa"
  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}