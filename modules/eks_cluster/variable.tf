variable "vpc_id" {
  type = string
}
variable "eks_environment" {
  type = string
}
variable "security_group_name" {
  type = string
}
variable "eks_cluster_name" {
  type = string
}
variable "eks_iam_role_name" {
  type = string
}
variable "eks_policy_arn" {
  description = "IAM Policy to be attached to role"
  type = list
}
variable "eks_kms_key_arn" {
  type = string
}
variable "vpc_subnet_ids" {
  description = "IAM Policy to be attached to role"
  type = list
}
