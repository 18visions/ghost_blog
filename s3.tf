# create s3 bucket for ansible script used for ghost user_data
resource "aws_s3_bucket" "ghost-ansible" {
  bucket = "ghost-ansible"
  tags = {
    Name = "ghost-ansible"
  }
}

data "archive_file" "ghost-ansible" {
  type        = "zip"
  source_dir  = "${path.module}/ansible"
  output_path = "${path.module}/ghost-ansible.zip"
}

resource "aws_s3_object" "ghost-ansible" {
  bucket = aws_s3_bucket.ghost-ansible.bucket
  key    = "ghost/ghost-ansible.zip"
  source = data.archive_file.ghost-ansible.output_path
  etag   = "${data.archive_file.ghost-ansible.output_md5}"
}
