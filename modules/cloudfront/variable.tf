variable "name" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "s3_bucket_regional_domain_name" {
  type = string
}

variable "default_root_object" {
  type    = string
  default = "index.html"
}


variable "origin_path" {
  type    = string
  default = ""
}

variable "domain_name" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
  description = "ARN del certificado ACM para asociar a CloudFront"
}