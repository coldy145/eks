variable "vpc_id" {
  type = string
  default = "vpc-008a835fed3dd8cad"
}
variable "eks_environment" {
  type = string
  default = "sit"
}
variable "security_group_name" {
  type = string
  default = "eks_cluster_sg"
}
//variable "eks_cluster_name" {
//  type = string
//  default = "sit-ekscluster"
//}
variable "eks_iam_role_name" {
  type = string
  default = "eks_cluster_role"
}
variable "eks_policy_arn" {
  description = "IAM Policy to be attached to role"
  type = list
  default = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy","arn:aws:iam::aws:policy/AmazonEKSServicePolicy"]
}

variable "eks_kms_key_arn" {
  type = string
  default = "arn:aws:kms:us-east-2:449776653265:key/883cb5c5-5a6e-4aa3-b517-03252fd789b7"
}

variable "vpc_subnet_ids" {
  description = "IAM Policy to be attached to role"
  type = list
  default = ["subnet-02aa47eeb979ac433","subnet-060f58c75360b5753","subnet-0ad2e8255b6ce1883"]
}
