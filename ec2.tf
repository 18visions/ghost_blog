# ec2 instance using t3.small
resource "aws_instance" "ghost-web-001" {
  # base ubuntu image in aws
  ami           = "ami-00c257e12d6828491"
  instance_type = "t3.small"
  iam_instance_profile = aws_iam_instance_profile.ghost-web-prod.name
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data = base64decode(templatefile("${path.module}/user_data.sh", {
    zip = "ghost-${data.archive_file.ghost-ansible.output_md5}.zip"
    s3_bucket = aws_s3_bucket.ghost-ansible.name
    hostname = "ghost-web-001"
  }))

  root_block_device {
    volume_type = "gp3"
    throughput  = 125
    iops        = 3000
    volume_size = 200
  }

  tags = {
    Name     = "ghost-web-001"
    OS       = "Ubuntu"
    Platform = "Linux"
  }
}