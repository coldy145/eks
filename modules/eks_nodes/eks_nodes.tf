resource "aws_iam_role" "eks_node_iam_role" {
  name = var.eks_node_role_name

  assume_role_policy = <<EOF
{
        "Version": "2012-10-17",
        "Statement": [
        {
            "Sid" : "",
            "Effect" : "Allow",
            "Principal" : {
            "Service" : "${var.ec2_service_principal}"
            },
            "Action" : "sts:AssumeRole"
        }
        ]
}
EOF
}

resource "aws_iam_policy" "xbp_bucket_policy" {
  name        = "xbp-binary-bucket"
  path        = "/"
  description = "Bucket Access Policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = ["${var.bucket_arn}",
                    "${var.bucket_arn}/*"]
      },
    ]
  })
}
resource "aws_iam_policy" "cloudwatch_policy" {
  name        = "cloudwatch"
  path        = "/"
  description = "Bucket Access Policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:CreateLogGroup",
                "logs:PutLogEvents"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeLaunchTemplateVersions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  role       = aws_iam_role.eks_node_iam_role.name
  count      = "${length(var.eks_node_policy_arn)}"
  policy_arn = "${var.eks_node_policy_arn[count.index]}"
}

resource "aws_iam_role_policy_attachment" "bucket_policy_attachment" {
  role       = aws_iam_role.eks_node_iam_role.name
  policy_arn = aws_iam_policy.xbp_bucket_policy.arn
}
resource "aws_iam_role_policy_attachment" "cloiudwatch_policy_attachment" {
  role       = aws_iam_role.eks_node_iam_role.name
  policy_arn = aws_iam_policy.cloudwatch_policy.arn
}


resource "aws_launch_template" "ec2_launch_template" {
    name = var.ec2_template_name

    block_device_mappings {
        device_name = "/dev/xvda"
        ebs {
          volume_size = var.volume_size
          volume_type = "gp2"
        }
    }
    instance_type   = var.instance_type
    key_name        = var.keyname
  
  user_data = filebase64("${path.module}/ec2_bash.sh")
  depends_on = [
    aws_eks_node_group.eks_node_group
  ]
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = var.eks_cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_node_iam_role.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.node_asg_desired_size
    max_size     = var.node_asg_max_size
    min_size     = var.node_asg_min_size
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.role_policy_attachment
  ]

}
