# ec2 instance using t3.small
resource "aws_instance" "ghost-web-001" {
  # base ubuntu image in aws
  ami                    = "ami-0606dd43116f5ed57"
  instance_type          = "t3.small"
  iam_instance_profile   = aws_iam_instance_profile.ghost-web-prod.name
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data = base64encode(templatefile("templates/user_data.sh", {
    zip       = "ghost-${data.archive_file.ghost-ansible.output_md5}.zip"
    s3_bucket = aws_s3_bucket.ghost-ansible.bucket
    hostname  = "${var.environment}-ghost-web-001"
  }))

  root_block_device {
    volume_type = "gp3"
    throughput  = 125
    iops        = 3000
    volume_size = 200
    tags = {
      Name   = "${var.environment}-ghost-web-001-rootvol"
      Backup = "true"
    }
  }

  metadata_options {
    http_tokens               = "required"  # Enforces the use of IMDSv2
    http_endpoint             = "enabled"   # Enables the metadata service
    http_put_response_hop_limit = 2         # (Optional) Controls the allowed network hops for metadata requests
    http_protocol_ipv6        = "disabled"  # (Optional) Disable IPv6 if not needed
  }

  tags = {
    Name        = "${var.environment}-ghost-web-001"
    OS          = "Ubuntu"
    Platform    = "Linux"
    environment = var.environment
  }
}

resource "aws_dlm_lifecycle_policy" "weekly_snapshot" {
  description        = "Daily EBS snapshot policy for blog volume"
  execution_role_arn = aws_iam_role.dlm.arn
  state              = "ENABLED"
  policy_details {
    resource_types = ["VOLUME"]
    target_tags = {
      Backup = "true"
    }
    schedule {
      name = "daily-snapshot"
      create_rule {
        interval = 24
        interval_unit = "HOURS"
        times = ["00:00"]
      }
      retain_rule {
        count = 2
      }
    }
  }
}
