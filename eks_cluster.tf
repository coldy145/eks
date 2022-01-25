
module "eks_cluster" {
    source              = "./modules/eks_cluster"
    vpc_id              = var.vpc_id
    security_group_name = var.security_group_name
    eks_environment     = var.eks_environment
    eks_cluster_name    = var.eks_cluster_name
    eks_iam_role_name   = var.eks_iam_role_name
    eks_policy_arn      = var.eks_policy_arn
    eks_kms_key_arn     = var.eks_kms_key_arn
    vpc_subnet_ids      = var.vpc_subnet_ids
}
