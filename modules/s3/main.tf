locals {
  owner           = "cemd"
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name

  # dynamic "website" {
  #   for_each = var.enable_redirect ? [1] : []
  #   content {
  #     redirect_all_requests_to {
  #       host_name = var.redirect_host
  #       protocol  = var.redirect_protocol
  #     }
  #   }
  # }

  tags = {
    Name  = var.bucket_name
    Owner = local.owner
  }
}


resource "aws_s3_bucket_website_configuration" "s3_bucket_website" {
  count       = var.enable_website_index ? 1 : 0
  depends_on  = [ aws_s3_bucket.s3_bucket ]
  bucket      = aws_s3_bucket.s3_bucket.bucket

  index_document {
    suffix = var.index_document_suffix
  }
}


resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.s3_bucket.bucket

  block_public_acls       = lookup(var.public_access_block_config, "block_public_acls", true)
  ignore_public_acls      = lookup(var.public_access_block_config, "ignore_public_acls", true)
  block_public_policy     = lookup(var.public_access_block_config, "block_public_policy", true)
  restrict_public_buckets = lookup(var.public_access_block_config, "restrict_public_buckets", true)
}

resource "aws_s3_bucket_policy" "this" {
  depends_on = [ aws_s3_bucket_public_access_block.this ]
  count  = length(var.bucket_policy_json) > 0 ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.bucket
  policy = var.bucket_policy_json
}
