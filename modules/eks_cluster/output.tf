output "ClusterName" {
  value = aws_eks_cluster.eks_cluster.name
}

output "CertificateAuthorityData" {
  value = aws_eks_cluster.eks_cluster.certificate_authority
}

output "Endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}