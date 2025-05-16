locals {
  owner           = "cemd"
}

resource "aws_cloudfront_origin_access_control" "this" {
  name               = var.name
  description        = "Managed by Terraform"
  origin_access_control_origin_type = "s3"
  signing_behavior   = "always"
  signing_protocol   = "sigv4"
}


resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  default_root_object = var.default_root_object

  origin {
    domain_name              = var.s3_bucket_regional_domain_name
    origin_id                = "s3-${var.bucket_name}"
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
    origin_path              = var.origin_path
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-${var.bucket_name}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
    cloudfront_default_certificate = false
  }
  aliases = [var.domain_name]

  depends_on = [aws_cloudfront_origin_access_control.this]
  tags = {
    Name  = var.bucket_name
    Owner = local.owner
  }
}

