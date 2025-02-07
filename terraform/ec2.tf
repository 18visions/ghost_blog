# ec2 instance using t3.small
resource "aws_instance" "ghost-web-001" {
  # base ubuntu image in aws
  ami           = "ami-0606dd43116f5ed57"
  instance_type = "t3.small"
  iam_instance_profile = aws_iam_instance_profile.ghost-web-prod.name
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data = base64encode(templatefile("templates/user_data.sh", {
    zip = "ghost-${data.archive_file.ghost-ansible.output_md5}.zip"
    s3_bucket = aws_s3_bucket.ghost-ansible.bucket
    hostname = "ghost-web-001"
  }))

  root_block_device {
    volume_type = "gp3"
    throughput  = 125
    iops        = 3000
    volume_size = 200
    tags = {
      Name = "ghost-web-001-rootvol"
      Backup = "true"
    }
  }

  tags = {
    Name     = "ghost-web-001"
    OS       = "Ubuntu"
    Platform = "Linux"
  }
}

resource "aws_dlm_lifecycle_policy" "weekly_snapshot" {
  description        = "Weekly EBS snapshot policy for blog server"
  execution_role_arn = aws_iam_role.dlm.arn
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]

    # Target volumes that have this tag
    target_tags = {
      Backup = "true"
    }

    schedule {
      name = "weekly-snapshot"

      # Create a snapshot every 1 week
      create_rule {
        interval      = 1
        interval_unit = "WEEKS"
      }

      # Retain the last 2 snapshots
      retain_rule {
        count = 2
      }
    }
  }
}
