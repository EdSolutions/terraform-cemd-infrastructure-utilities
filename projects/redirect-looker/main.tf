terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.1.0"
}

provider "aws" {
  region = var.aws_region
}


///////////////////////////////////////////
////////////////// S3 /////////////////////
///////////////////////////////////////////
module "redirect_bucket" {
  source = "../../modules/s3"

  bucket_name            = "engagement.cemd.org"
  enable_website_index = true
  index_document_suffix = "index.html"
  public_access_block_config = {
    block_public_acls       = true
    ignore_public_acls      = true
    block_public_policy     = false
    restrict_public_buckets = false
  }

  bucket_policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::engagement.cemd.org/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::019773216718:distribution/EGEQ2PUNPOU4T"
          }
        }
      }
    ]
  })
}

///////////////////////////////////////////
///////////// CLOUDFRONT //////////////////
///////////////////////////////////////////
module "cloudfront" {
  source = "../../modules/cloudfront"

  name                           = "redirect-looker-cloudfront"
  bucket_name                    = "engagement.cemd.org"
  s3_bucket_regional_domain_name = module.redirect_bucket.bucket_regional_domain_name
  default_root_object           = "index.html"
  domain_name = "engagement.cemd.org"
  acm_certificate_arn = module.domain.certificate_arn
}

///////////////////////////////////////////
/////////// DOMAIN CONFIG /////////////////
///////////////////////////////////////////
module "domain" {
  source = "../../modules/domain"
  domain_name = "engagement.cemd.org"
  cloudfront_domain_name = module.cloudfront.domain_name
  cloudfront_hosted_zone_id = module.cloudfront.cloudfront_hosted_zone_id
  record_name = "engagement"
  record_type = "A"
}