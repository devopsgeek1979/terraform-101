###############################################################################
# infra-aws-ec2  |  main.tf
# Production-grade EC2: encrypted EBS, IMDSv2, private-only, SSM role
###############################################################################

# ── Security Group ────────────────────────────────────────────────────────────
resource "aws_security_group" "ec2" {
  name        = "infra-aws-sg-ec2-${var.environment}"
  description = "EC2 instance SG — egress only"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all egress"
  }

  tags = { Name = "infra-aws-sg-ec2-${var.environment}" }
}

# ── IAM Instance Profile (SSM + least-privilege) ─────────────────────────────
resource "aws_iam_role" "ec2" {
  name = "infra-aws-role-ec2-${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "infra-aws-profile-ec2-${var.environment}"
  role = aws_iam_role.ec2.name
}

# ── Launch Template ───────────────────────────────────────────────────────────
resource "aws_launch_template" "this" {
  name_prefix            = "infra-aws-lt-${var.environment}-"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ec2.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2.name
  }

  # IMDSv2 enforced
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  # Encrypted root volume
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.root_volume_size_gb
      volume_type           = "gp3"
      encrypted             = true
      kms_key_id            = var.kms_key_arn
      delete_on_termination = true
    }
  }

  monitoring { enabled = true }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "infra-aws-ec2-${var.environment}"
      Environment = var.environment
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name        = "infra-aws-ebs-${var.environment}"
      Environment = var.environment
    }
  }

  lifecycle { create_before_destroy = true }
}

# ── EC2 Instance ──────────────────────────────────────────────────────────────
resource "aws_instance" "this" {
  count     = var.instance_count
  subnet_id = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tags = { Name = "infra-aws-ec2-${var.environment}-${count.index + 1}" }
}
