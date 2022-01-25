variable "eks_node_role_name" {
  type = string
}

variable "ec2_service_principal" {
  type = string
}

variable "bucket_arn" {
  type = string
}
variable "eks_node_policy_arn" {
  type = list
}
variable "ec2_template_name" {
  type = string
}
variable "volume_size" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "keyname" {
  type = string
}
variable "eks_cluster_name" {
  type = string
}
variable "node_group_name" {
  type = string
}
variable "subnet_ids" {
  type = list
}
variable "node_asg_desired_size" {
  type = number
}
variable "node_asg_max_size" {
  type = number
}
variable "node_asg_min_size" {
  type = number
}
variable "bucket_name" {
  type = string
  description = "Bucket Name"
}
