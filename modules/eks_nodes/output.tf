output "NodeInstanceRole" {
  value = aws_eks_node_group.eks_node_group.node_role_arn
}
output "ManagedEKSNodegroup" {
  value = aws_eks_node_group.eks_node_group.node_group_name
}
