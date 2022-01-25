variable "eks_node_role_name" {
  type = string
  default = "node-test-role"
}

variable "ec2_service_principal" {
  type = string
  default = "ec2.amazonaws.com"
}

variable "bucket_arn" {
  type = string
  default = "arn:aws:s3:::examplebucket"
}
variable "eks_node_policy_arn" {
  type = list
  default = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy","arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
             "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly","arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}
variable "ec2_template_name" {
  type = string
  default = "eks-node-template"
}
variable "volume_size" {
  type = string
  default = "20"
}
variable "instance_type" {
  type = string
  default = "t2.micro"
}
variable "keyname" {
  type = string
  default = "test-node"
}
variable "eks_cluster_name" {
  type = string
  default = "sit-ekscluster"
}
variable "node_group_name" {
  type = string
  default = "test-node-group"
}
variable "subnet_ids" {
  type = list
  default = ["subnet-02aa47eeb979ac433","subnet-060f58c75360b5753","subnet-0ad2e8255b6ce1883"]
}
variable "node_asg_desired_size" {
  type = number
  default = 1
}
variable "node_asg_max_size" {
  type = number
  default = 4
}
variable "node_asg_min_size" {
  type = number
  default = 1
}
variable "bucket_name" {
  type = string
  description = "Bucket Name"
  default = "examplebucket"
}