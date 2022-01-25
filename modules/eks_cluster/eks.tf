resource "aws_security_group" "ControlPlaneSecurityGroup" {
    name        = var.security_group_name
    description = "Allow TLS inbound traffic"
    vpc_id      = var.vpc_id
    tags = {
        Name = "eks_cluster_sg"
    }
}

resource "aws_security_group_rule" "ingress_rule" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.ControlPlaneSecurityGroup.id
}
resource "aws_security_group_rule" "egress_rule" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  #ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.ControlPlaneSecurityGroup.id
}

resource "aws_ssm_parameter" "eks_clusterName" {
  name  = "/k8s/${var.eks_environment}/clusterName"
  type  = "String"
  value = var.eks_cluster_name
}

resource "aws_iam_role" "eks_iam_role" {
  name = var.eks_iam_role_name

  assume_role_policy = <<EOF
{
        "Version": "2012-10-17",
        "Statement": [
        {
            "Sid" : "",
            "Effect" : "Allow",
            "Principal" : {
            "Service" : "eks.amazonaws.com"
            },
            "Action" : "sts:AssumeRole"
        }
        ]
}
EOF
}

resource "aws_iam_policy" "kms_policy" {
  name        = "kms_key_policy"
  path        = "/"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:CreateGrant"
        ]
        Effect   = "Allow"
        Resource = "${var.eks_kms_key_arn}"
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  role       = aws_iam_role.eks_iam_role.name
  count      = "${length(var.eks_policy_arn)}"
  policy_arn = "${var.eks_policy_arn[count.index]}"
}

resource "aws_iam_role_policy_attachment" "kms_policy_attachment" {
  role       = aws_iam_role.eks_iam_role.name
  policy_arn = aws_iam_policy.kms_policy.arn
}

resource "aws_eks_cluster" "eks_cluster" {
    name     = var.eks_cluster_name
    role_arn = aws_iam_role.eks_iam_role.arn 

    vpc_config {
        subnet_ids = var.vpc_subnet_ids
    }
    encryption_config {
        resources = ["secrets"]
        provider {
            key_arn = var.eks_kms_key_arn
        }
    } 
  depends_on = [
    aws_iam_role_policy_attachment.role_policy_attachment
  ]
}
