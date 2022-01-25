module "eks_node" {
    source                  = "./modules/eks_nodes"
    eks_cluster_name        = module.eks_cluster.ClusterName
    eks_node_role_name      = var.eks_node_role_name
    ec2_service_principal   = var.ec2_service_principal
    bucket_arn              = var.bucket_arn
    eks_node_policy_arn     = var.eks_node_policy_arn
    ec2_template_name       = var.ec2_template_name
    volume_size             = var.volume_size
    instance_type           = var.instance_type
    keyname                 = var.keyname
    node_group_name         = var.node_group_name
    subnet_ids              = var.subnet_ids
    node_asg_desired_size   = var.node_asg_desired_size
    node_asg_max_size       = var.node_asg_max_size
    node_asg_min_size       = var.node_asg_min_size
    bucket_name             = var.bucket_name
}
